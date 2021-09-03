library(dplyr)

test_that("Höchste Wahlkreisnummer = 299",
          {expect_equal(max(btwkandidaten2021$wahlkreis, na.rm = TRUE), "299")})

test_that("Number of candidates is 6211",
          {expect_equal(nrow(btwkandidaten2021), 6211)})

test_that("If liste is missing, listenplatz must be missing, too",
          {expect_equal(filter(btwkandidaten2021, is.na(liste)) %>%
                         count(listenplatz) %>%
                         pull(listenplatz),
                       NA_real_)})

test_that("If listenplatz is missing, liste must be missing, too",
          {expect_equal(filter(btwkandidaten2021, is.na(listenplatz)) %>%
                         count(liste) %>%
                         pull(liste),
                       NA_character_)})

test_that("If wahlkreis is missing, listenplatz must NOT be missing",
          {expect_equal(filter(btwkandidaten2021, is.na(wahlkreis)) %>%
                         count(listenplatz) %>%
                         filter(is.na(listenplatz)) %>% nrow(),
                       0)})
