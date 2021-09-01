pacman::p_load("tidyverse", "rvest", "here", "glue", "testthat", "usethis")


## PARTY NAMES =============================

url_parties <- "https://www.bundeswahlleiter.de/info/presse/mitteilungen/bundestagswahl-2021/23_21_parteien-wahlteilnahme.html"
page_parties <- read_html(url_parties)
parties <- html_nodes(page_parties, css = "table.tablesaw") %>%
  map_dfr(html_table) %>%
  select(kurzbezeichnung = Kurzbezeichnung, parteiname = Parteiname)



## CANDIDATES ==============================

scrape_candidate_list <- function(letter) {
  url <- glue("https://www.bundeswahlleiter.de/bundestagswahlen/2021/wahlbewerber/bund-99/{letter}.html")
  page <- read_html(url)
  table <- html_node(page, css = "table.tablesaw") %>%  html_table()
  table
}

# Wrapper for safely scraping each letter
scrape_candidate_list_safely <- safely(scrape_candidate_list)

candidate_lists <- map(letters, scrape_candidate_list_safely)
candidate_lists <- set_names(candidate_lists, letters)

# Any letters missing?
transpose(candidate_lists) %>%
  pluck("error") %>%
  compact()

# Cleaning and transformations
candidates <- transpose(candidate_lists) %>% pluck("result") %>%
  compact() %>%
  bind_rows(.id = "buchstabe") %>%
  rename(name = 2, geburtsjahr = 3, partei = 4, kandidiert = 5) %>%
  mutate(buchstabe = str_to_upper(buchstabe)) %>%
  separate(name, into = c("nachname", "vorname"), sep = ", ", remove = FALSE) %>%
  # Split kandidiert into direkt and liste
  separate(kandidiert, into = c("item1", "item2"), sep = "\\n\\s+und\\s", remove = FALSE) %>%
  mutate(wahlkreis = ifelse(str_detect(item1, "Wahlkreis"), item1, NA),
         wahlkreis = str_remove(wahlkreis, "Wahlkreis "),
         liste = case_when(
           str_detect(item1, "Land") ~ item1,
           str_detect(item2, "Land") ~ item2
         ),
         listenplatz = str_extract(liste, "\\d+"),
         listenplatz = as.numeric(listenplatz),
         liste = str_match(liste, "Land (.+) \\(")[, 2],
         partei = ifelse(str_detect(partei, "EB: "), "Einzelbewerber:in", partei)) %>%
  left_join(parties, by = c("partei" = "kurzbezeichnung")) %>%
  select(buchstabe:partei, parteiname, everything(), -c(item1, item2, kandidiert))


## CHECKS =======================

test_that("Maximum Wahlkreis = 299",
          expect_equal(max(candidates$wahlkreis, na.rm = TRUE), "299"))

test_that("If liste is missing, listenplatz must be missing, too",
          expect_equal(filter(candidates, is.na(liste)) %>%
                         count(listenplatz) %>%
                         pull(listenplatz),
                       NA_real_))

test_that("If listenplatz is missing, liste must be missing, too",
          expect_equal(filter(candidates, is.na(listenplatz)) %>%
                         count(liste) %>%
                         pull(liste),
                       NA_character_))

test_that("If wahlkreis is missing, listenplatz must NOT be missing",
          expect_equal(filter(candidates, is.na(wahlkreis)) %>%
                         count(listenplatz) %>%
                         filter(is.na(listenplatz)) %>% nrow(),
                       0))


use_data(candidates)
