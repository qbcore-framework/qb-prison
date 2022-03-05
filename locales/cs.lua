local Translations = {
    error = {
        ["missing_something"] = "Vypadá to, že vám něco chybí...",
        ["not_enough_police"] = "Není dost policistů..",
        ["door_open"] = "Dveře jsou otevřené..",
        ["cancelled"] = "Proces zrušen...",
        ["didnt_work"] = " Nepovedlo se...", 
        ["emty_box"] = "Box je prázdný..",
        ["injail"] = "Jste ve vězení po dobu %{Time} měsíců..",
        ["item_missing"] = "Chybí ti nějaký předmět..",
        ["escaped"] = "Utekl jsi... Vypadni odsud!",
        ["do_some_work"] = "Udělejte nějakou práci pro snížení trestu, okamžitá práce: %{currentjob} ",
    },
    success = {
        ["found_phone"] = "Našel jsi telefon...",
        ["timecut"] = "Odpracoval jsi nějaký čas z trestu.",
        ["free"] = "Jsi volný! Užijte si to! :)",
        ["timesup"] = "Váš trest skončil! Zajděte do návštěvnického centra!",
    },
    info = {
        ["timeleft"] = "Zbývá Vám %{JAILTIME} měsíců",
        ["lost_job"] = "Jsi nezaměstnaný",
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true})
