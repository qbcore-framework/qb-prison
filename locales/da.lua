local Translations = {
    error = {
        ["missing_something"] = "Det lader til du mangler noget...",
        ["not_enough_police"] = "Ikke nok betjente..",
        ["door_open"] = "Døren er allerede åben..",
        ["cancelled"] = "Handling afbrudt..",
        ["didnt_work"] = "Det virkede ikke..",
        ["emty_box"] = "Kassen er tom..",
        ["injail"] = "Du er i brummen i %{Time} måneder..",
        ["item_missing"] = "Du mangler en enhed..",
        ["escaped"] = "Du flygtede... Løb forhelvede!",
        ["do_some_work"] = "Lav noget arbejde for at nedsætte din tid i brummen, nuværende job: %{currentjob} ",
    },
    success = {
        ["found_phone"] = "Du fandt en mobil..",
        ["time_cut"] = "Du har arbejdet dig til mindre tid.",
        ["free_"] = "Du er fri! Nyd det! :)",
        ["timesup"] = "Din tid i brummen er ovre! Du kan udskrive dig i receptionen",
    },
    info = {
        ["timeleft"] = "Du har stadig %{JAILTIME} måneder tilbage...",
        ["lost_job"] = "Du er arbejdsløs",
    }
}
Lang = Locale:new({
phrases = Translations,
warnOnMissing = true})
