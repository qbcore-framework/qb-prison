local Translations = {
    error = {
        ["missing_something"] = "Es scheint, als würde dir etwas fehlen...",
        ["not_enough_police"] = "Nicht genug Polizisten..",
        ["door_open"] = "Die Tür ist bereits offen...",
        ["cancelled"] = "Prozess abgebrochen...",
        ["didnt_work"] = "Es hat nicht funktioniert...",
        ["emty_box"] = "Die Box ist leer...",
        ["injail"] = "Du bist für %{Time} Monate im Gefängnis...",
        ["item_missing"] = "Dir fehlt ein Gegenstand...",
        ["escaped"] = "Du bist ausgebrochen, Schnell weg!",
        ["do_some_work"] = "Mache etwas Arbeit um deine Haftzeit zu verkürzen, Job: %{currentjob} ",
        ["security_activated"] = "Das höchste Sicherheitsniveau ist aktiv, bleib in den Zellenblöcken!"
    },
    success = {
        ["found_phone"] = "Du hast ein Telefon gefunden...",
        ["time_cut"] = "Du hast deine Strafe durch Arbeit verkürzt.",
        ["free_"] = "Du bist frei! Genieß es! :)",
        ["timesup"] = "Deine Zeit ist Vorbei, Gehe zum Besucher Zentrum",
    },
    info = {
        ["timeleft"] = "Du musst noch %{JAILTIME} Monate absitzen",
        ["lost_job"] = "Du hast deine Job verloren und bist jetzt Arbeitslos",
        ["job_interaction"] = "[E] Elektrizitätsarbeit",
        ["job_interaction_target"] = "Mache %{job}-Arbeit",
        ["received_property"] = "Du hast dein Eigentum zurückbekommen...",
        ["seized_property"] = "Dein Eigentum wurde beschlagnahmt, du bekommst alles zurück, wenn deine Zeit abgelaufen ist...",
        ["cells_blip"] = "Zellen",
        ["freedom_blip"] = "Gefängnis-Empfang",
        ["canteen_blip"] = "Kantine",
        ["work_blip"] = "Gefängnisarbeit",
        ["target_freedom_option"] = "Zeit überprüfen",
        ["target_canteen_option"] = "Essen holen",
        ["police_alert_title"] = "Neuer Anruf",
        ["police_alert_description"] = "Gefängnisausbruch",
        ["connecting_device"] = "Gerät verbinden",
        ["working_electricity"] = "Drähte verbinden"
    }
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
