ConfigAmbulanceJob = {
    timerrevive1 = 600000,
    timerrevive2 = 600000,
    tempseffetrespawn = 6000,

    BlipAmbulance = {
        {x = 299.73165893555, y = -584.80236816406, z = 43.284061431885},
    },
    Boss = {
        {x = 334.83261108398, y = -594.10131835938, z = 43.284107208252},
    },
    Coffre = {
        {x = 337.85278320313, y = -595.8310546875, z = 43.284057617188},
    },
    Vestiaire = {
        {x = 302.1064453125, y = -598.94842529297, z = 43.284061431885},
    },

    Pharmacie = {
        {x = 306.30978393555, y = -601.65100097656, z = 43.28409576416},
    },
    PharmacieItem = {
		{Name = 'Bandage', Label = 'bandage', Index = 1},
		{Name = 'Medikids', Label = 'medikit', Index = 1}
    },

    AscenseurHeliport = {
        {x = 338.55603027344, y = -583.78729248047, z = 74.161758422852}
    },
    AscenseurAccueil = {
        {x = 332.39401245117, y = -595.65850830078, z = 43.284111022949}
    },
    AscenseurGarage = {
        {x = 340.1330871582, y = -584.77044677734, z = 28.796846389771}
    },


    GarageList = {
        {x = 333.52893066406, y = -574.76867675781, z = 28.796838760376},
    },
    GarageRentrer = {
        {x = 326.74594116211, y = -572.80938720703, z = 28.796838760376},
    },
    VehiculesList = {
		{ name = 'Ambulance', model = 'ambulance'},
	},
    SortieVehicule = vector3(333.52893066406, -574.76867675781, 28.796838760376),

    GarageHeliList = {
        {x = 351.36318969727, y = -587.80786132813, z = 74.16178894043}
    },
    GarageHeliRentrer = {
        {x = 351.36318969727, y = -587.80786132813, z = 74.16178894043}
    },
    HeliList = {
		{ name = 'Polmav', model = 'polmav'},
	},
    SortieHeli = vector3(351.36318969727, -587.80786132813, 74.16178894043),


    Uniforms = {
        ambulance = {
            male = {
                tshirt_1 = 129,  tshirt_2 = 0,
                torso_1 = 250,   torso_2 = 0,
                decals_1 = 58,   decals_2 = 1,
                arms = 85,      arms_2 = 0,
                pants_1 = 96,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 126,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 35,  tshirt_2 = 0,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 7,   decals_2 = 3,
                arms = 44,      arms_2 = 0,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },
        medecin = {
            male = {
                tshirt_1 = 129,  tshirt_2 = 0,
                torso_1 = 250,   torso_2 = 0,
                decals_1 = 58,   decals_2 = 1,
                arms = 85,      arms_2 = 0,
                pants_1 = 96,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 126,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 35,  tshirt_2 = 0,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 7,   decals_2 = 3,
                arms = 44,      arms_2 = 0,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },
        chef_medecin = {
            male = {
                tshirt_1 = 129,  tshirt_2 = 0,
                torso_1 = 250,   torso_2 = 0,
                decals_1 = 58,   decals_2 = 1,
                arms = 85,      arms_2 = 0,
                pants_1 = 96,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 126,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 35,  tshirt_2 = 0,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 7,   decals_2 = 3,
                arms = 44,      arms_2 = 0,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },
        boss = {
            male = {
                tshirt_1 = 129,  tshirt_2 = 0,
                torso_1 = 250,   torso_2 = 0,
                decals_1 = 58,   decals_2 = 1,
                arms = 85,      arms_2 = 0,
                pants_1 = 96,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 126,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 35,  tshirt_2 = 0,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 7,   decals_2 = 3,
                arms = 44,      arms_2 = 0,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },
        sac = {
            male = {bags_1 = 10, bags_2 = 15},
            female = {bags_1 = 10, bags_2 = 15}
        }
    }
}
