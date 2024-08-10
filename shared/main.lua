Config = Config or {}

-- If you wanna add more characters, you need to add more spawn points in the Config.SpawnCharacters table
Config.MaxCharacters = 5

Config.StarterItems = {
    { name = 'phone', amount = 1 },
    {
        name = 'id_card',
        amount = 1,
        metadata = function(source)
            assert(GetResourceState('qbx_idcard') == 'started',
                'qbx_idcard resource not found. Required to give an id_card as a starting item')
            return exports.qbx_idcard:GetMetaLicense(source, { 'id_card' })
        end
    },
    {
        name = 'driver_license',
        amount = 1,
        metadata = function(source)
            assert(GetResourceState('qbx_idcard') == 'started',
                'qbx_idcard resource not found. Required to give an id_card as a starting item')
            return exports.qbx_idcard:GetMetaLicense(source, { 'driver_license' })
        end
    },
}

Config.CreatorCoords = vector4(-902.3749, -369.5003, 113.0742, 115.4802)

Config.SpawnCharacters = {
    ["1"] = {
        pedCoords = vector4(-911.0777, -379.3916, 112.4562, -61.9697),
        anim = { 'anim@heists@fleeca_bank@hostages@intro', 'intro_loop_ped_a' },
        offset = vector3(0.0, 0.0, 0.0),
        fov = 22.0
    },
    ["2"] = {
        pedCoords = vector4(-907.2104, -379.0488, 112.4511, 126.1),
        anim = { 'timetable@maid@couch@', 'base' },
        offset = vector3(0.0, 0.0, 0.0),
        fov = 20.0
    },
    ["3"] = {
        pedCoords = vector4(-919.2039, -384.8792, 112.6746, 294.4629),
        anim = { 'anim@heists@heist_corona@single_team', 'single_team_loop_boss' },
        offset = vector3(0.0, 0.0, 0.3),
        fov = 40.0
    },
    ["4"] = {
        pedCoords = vector4(-914.5677, -385.6498, 112.7096, 214.8082),
        anim = { 'anim@amb@casino@hangout@ped_male@stand@02b@base', 'base' },
        offset = vector3(0.0, 0.0, 0.3),
        fov = 40.0
    },
    ["5"] = {
        pedCoords = vector4(-909.5645, -377.3061, 112.9847, -157.7374),
        anim = { 'switch@michael@tv_w_kids', '001520_02_mics3_14_tv_w_kids_exit_trc' },
        offset = vector3(0.0, 0.0, -0.6),
        fov = 35.0
    },
}


Config.DefaultCamera = {
    coords = vector3(-906.2151, -373.2677, 116.5074),
    rotation = vector3(-15.9563, 0.0, 153.6563),
    fov = 50.0
}


Config.UI = {
    colors = {
        main = "#09ffc1",
    },
    locale = {
        characters_title = "Characters",
        create_new_character = "Create New Character",

        creator = {
            character_creator = "Character Creator",
            error = "Please fill this field. (2-32 chars)",
            is_required = "Field is required.",
            firstname = "First Name",
            lastname = "Last Name",
            gender = "Gender",
            male = "Male",
            female = "Female",
            nationality = "Nationality",
            birthdate = "Date of Birth",
            years = "Years",
            terms_of_server = "I agree to the terms of the server",
            terms_of_server_description = "Upon creating a character, you agree to the terms of the server.",

            create = "Create Character",
            cancel = "Cancel",
        },
        preview = {
            firstname = "First Name",
            lastname = "Last Name",
            gender = "Gender",
            nationality = "Nationality",
            birthdate = "Date of Birth",
            cash = "Cash",
            bank = "Bank",
            job = "Job",
            gang = "Gang",
            grade = "Grade",

            select = "Select Character",
            delete = "Delete Character",
        },
        removing = {
            delete_character = "Delete Character",
            you_are_sure = "Are you sure you want to delete this character: ",
            action_irreversible = "This action is irreversible. All data will be lost permanently.",

            cancel = "No, Cancel",
            delete = "Yes, Delete this character",
        }
    }
}
