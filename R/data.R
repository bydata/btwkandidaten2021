#' Direkt- und Listenkandidat:innen zur Bundestagswahl 2021
#'
#' Alle Kandidierenden in alphabetischer Reihenfolge.
#' Quelle: Bundeswahlleiter (Stand: 03.09.2021)
#'
#' @format A tibble / data frame with 6211 rows and 10 variables:
#' \describe{
#'   \item{buchstabe}{Anfangsbuchstabe des Nachnamens}
#'   \item{name}{Voller Name, Format: \[Titel\] Nachname, Vorname}
#'   \item{nachname}{Nachname}
#'   \item{vorname}{Vorname}
#'   \item{geburtsjahr}{Geburtsjahr}
#'   \item{partei}{Partei (Kurzform auf Stimmzettel)}
#'   \item{parteiname}{Partei (vollständiger Name)}
#'   \item{wahlkreis}{Falls Kandidat:in im Wahlkreis kandidiert die
#'       Wahlkreisnummer; bei ausschließlich auf der Landesliste einer Partei
#'       Kandidierenden NA}
#'   \item{liste}{Name der Liste (Bundesland), ausschließlich direkt Kandidierende: NA}
#'   \item{listenplatz}{Listenplatz, NA wenn ausschließlich direkt kandidiert}
#' }
#' @source \url{https://www.bundeswahlleiter.de/}
"btwkandidaten2021"
