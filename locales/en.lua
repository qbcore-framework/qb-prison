local Translations = {
    error = {
        ["missing_something"] = "It looks like you are missing something...",
        ["not_enough_police"] = "Not enough Police..",
        ["door_open"] = "The door is already open..",
        ["cancelled"] = "Process Canceled..",
        ["didnt_work"] = "It did not work..",
        ["emty_box"] = "The Box Is Empty..",
        ["injail"] = "You're in jail for %{Time} months..",
        ["item_missing"] = "You are missing an Item..",
        ["escaped"] = "You escaped... Get the hell out of here.!",
        ["do_some_work"] = "Do some work for sentence reduction, instant job: %{currentjob} ",
        ["infinite"] = "You are in jail forever, sorry"
    },
    success = {
        ["found_phone"] = "You found a phone..",
        ["time_cut"] = "You've worked some time off your sentence.",
        ["free_"] = "You're free! Enjoy it! :)",
        ["timesup"] = "Your time is up! Check yourself out at the visitors center",
    },
    info = {
        ["timeleft"] = "You still have to... %{JAILTIME} months",
        ["lost_job"] = "You're Unemployed",
        ["forever"] = "It seems like you are stuck here forever.",
        ["cantfree"] = "It seems like this person was jailed forever"
    }
}
Lang = Locale:new({
phrases = Translations,
warnOnMissing = true})
