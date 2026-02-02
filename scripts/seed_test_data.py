#!/usr/bin/env python3
"""
CoffeeNote Test Data Seeder

This script creates a test account and populates it with sample coffee shop visits
for testing the CoffeeNote iOS app.

Usage:
    1. First, download your Firebase service account credentials:
       - Go to Firebase Console > Project Settings > Service Accounts
       - Click "Generate new private key"
       - Save the JSON file as 'serviceAccountKey.json' in this directory

    2. Install dependencies:
       pip install firebase-admin requests

    3. Run the script:
       python seed_test_data.py

    Options:
       --email EMAIL       Test account email (default: test@gmail.com)
       --password PASSWORD Test account password (default: testtest)
       --visits N          Number of visits to create (default: 15)
       --wishlist N        Number of wishlist items to create (default: 5)
       --city CITY         City: seattle, la, portland, nyc, tokyo, indore, or all (default: all)
       --clear             Clear all visits and wishlist items (no seeding)
"""

import argparse
import json
import random
import uuid
from datetime import datetime, timedelta
from typing import Optional

import requests

# Firebase project configuration (from GoogleService-Info.plist)
FIREBASE_CONFIG = {
    "apiKey": "AIzaSyBiRkvHDWkIdw2Hf-0lfikbmraQyoXYrCw",
    "projectId": "coffeenoteios",
}

# Sample Seattle coffee shop data for realistic test entries
SAMPLE_COFFEE_SHOPS = [
    {
        "shopName": "Storyville Coffee",
        "address": "94 Pike St, Seattle, WA 98101",
        "latitude": 47.6090,
        "longitude": -122.3405,
        "drinks": ["Prologue Blend", "Chapter One", "Oat Latte", "Honey Lavender Latte"],
    },
    {
        "shopName": "Elm Coffee Roasters",
        "address": "240 2nd Ave S, Seattle, WA 98104",
        "latitude": 47.6001,
        "longitude": -122.3318,
        "drinks": ["Cortado", "Espresso", "Pour Over", "Cold Brew"],
    },
    {
        "shopName": "Victrola Coffee Roasters",
        "address": "310 E Pike St, Seattle, WA 98122",
        "latitude": 47.6142,
        "longitude": -122.3252,
        "drinks": ["Streamline Espresso", "Triborough Blend", "Single Origin", "Cappuccino"],
    },
    {
        "shopName": "Espresso Vivace",
        "address": "532 Broadway E, Seattle, WA 98102",
        "latitude": 47.6244,
        "longitude": -122.3209,
        "drinks": ["Vita Blend Espresso", "Macchiato", "Caffe Nico", "Dolce Latte"],
    },
    {
        "shopName": "Milstead & Co.",
        "address": "770 N 34th St, Seattle, WA 98103",
        "latitude": 47.6496,
        "longitude": -122.3502,
        "drinks": ["Rotating Single Origin", "Cortado", "Americano", "Oat Cappuccino"],
    },
    {
        "shopName": "Slate Coffee Roasters",
        "address": "5413 6th Ave NW, Seattle, WA 98107",
        "latitude": 47.6685,
        "longitude": -122.3631,
        "drinks": ["Deconstructed Latte", "White Coffee", "Espresso Flight", "Cold Brew"],
    },
    {
        "shopName": "Caffe Vita",
        "address": "1005 E Pike St, Seattle, WA 98122",
        "latitude": 47.6141,
        "longitude": -122.3188,
        "drinks": ["Caffe Del Sol", "Queen City Blend", "Theo Mocha", "Americano"],
    },
    {
        "shopName": "Lighthouse Roasters",
        "address": "400 N 43rd St, Seattle, WA 98103",
        "latitude": 47.6596,
        "longitude": -122.3416,
        "drinks": ["Helios Blend", "Ethiopian Yirgacheffe", "Sumatra", "Drip Coffee"],
    },
    {
        "shopName": "Anchorhead Coffee",
        "address": "1600 7th Ave, Seattle, WA 98101",
        "latitude": 47.6138,
        "longitude": -122.3340,
        "drinks": ["Voyager Espresso", "Nitro Cold Brew", "Mocha", "Lavender Latte"],
    },
    {
        "shopName": "Broadcast Coffee",
        "address": "1918 E Yesler Way, Seattle, WA 98122",
        "latitude": 47.6021,
        "longitude": -122.3055,
        "drinks": ["House Drip", "Iced Latte", "Cortado", "Chai Latte"],
    },
    {
        "shopName": "Starbucks Reserve Roastery",
        "address": "1124 Pike St, Seattle, WA 98101",
        "latitude": 47.6140,
        "longitude": -122.3165,
        "drinks": ["Reserve Espresso", "Nitro Cold Brew Flight", "Whiskey Barrel Aged", "Siphon Coffee"],
    },
    {
        "shopName": "Zeitgeist Coffee",
        "address": "171 S Jackson St, Seattle, WA 98104",
        "latitude": 47.5994,
        "longitude": -122.3327,
        "drinks": ["Americano", "Latte", "Mocha", "Drip Coffee"],
    },
    {
        "shopName": "Herkimer Coffee",
        "address": "7320 Greenwood Ave N, Seattle, WA 98103",
        "latitude": 47.6822,
        "longitude": -122.3556,
        "drinks": ["Espresso", "Gibraltar", "Pour Over", "Iced Coffee"],
    },
    {
        "shopName": "Caffe Ladro",
        "address": "600 Queen Anne Ave N, Seattle, WA 98109",
        "latitude": 47.6251,
        "longitude": -122.3567,
        "drinks": ["Ladro Blend", "Medici Latte", "Cold Brew", "Mocha"],
    },
    {
        "shopName": "Ada's Technical Books & Cafe",
        "address": "425 15th Ave E, Seattle, WA 98112",
        "latitude": 47.6232,
        "longitude": -122.3127,
        "drinks": ["Pour Over", "Espresso", "Latte", "Chai"],
    },
]

# Additional Seattle coffee shops for wishlist (places to visit)
SAMPLE_WISHLIST_SHOPS = [
    {
        "shopName": "Fulcrum Coffee",
        "address": "517 S Jackson St, Seattle, WA 98104",
        "latitude": 47.5988,
        "longitude": -122.3276,
    },
    {
        "shopName": "Olympia Coffee Roasting",
        "address": "2601 E Madison St, Seattle, WA 98112",
        "latitude": 47.6194,
        "longitude": -122.2986,
    },
    {
        "shopName": "Fonté Coffee Roaster",
        "address": "1421 34th Ave, Seattle, WA 98122",
        "latitude": 47.6125,
        "longitude": -122.2906,
    },
    {
        "shopName": "Boon Boona Coffee",
        "address": "1410 34th Ave, Seattle, WA 98122",
        "latitude": 47.6124,
        "longitude": -122.2908,
    },
    {
        "shopName": "Cafe Solstice",
        "address": "4116 University Way NE, Seattle, WA 98105",
        "latitude": 47.6580,
        "longitude": -122.3131,
    },
    {
        "shopName": "Remedy Teas",
        "address": "345 15th Ave E, Seattle, WA 98112",
        "latitude": 47.6224,
        "longitude": -122.3127,
    },
    {
        "shopName": "Cherry Street Coffee House",
        "address": "103 Cherry St, Seattle, WA 98104",
        "latitude": 47.6025,
        "longitude": -122.3340,
    },
    {
        "shopName": "Cafe Allegro",
        "address": "4214 University Way NE, Seattle, WA 98105",
        "latitude": 47.6590,
        "longitude": -122.3131,
    },
    {
        "shopName": "Mr West Cafe Bar",
        "address": "720 E Pike St, Seattle, WA 98122",
        "latitude": 47.6143,
        "longitude": -122.3220,
    },
    {
        "shopName": "Porchlight Coffee & Records",
        "address": "1517 12th Ave, Seattle, WA 98122",
        "latitude": 47.6150,
        "longitude": -122.3168,
    },
]

# LA coffee shops
SAMPLE_LA_COFFEE_SHOPS = [
    {
        "shopName": "Intelligentsia Coffee",
        "address": "3922 W Sunset Blvd, Los Angeles, CA 90029",
        "latitude": 34.0909,
        "longitude": -118.2619,
        "drinks": ["Black Cat Espresso", "House Drip", "Cortado", "Oat Latte"],
    },
    {
        "shopName": "Blue Bottle Coffee",
        "address": "582 Mateo St, Los Angeles, CA 90013",
        "latitude": 34.0401,
        "longitude": -118.2328,
        "drinks": ["New Orleans Iced", "Gibraltar", "Single Origin Pour Over", "Cappuccino"],
    },
    {
        "shopName": "Verve Coffee Roasters",
        "address": "833 S Spring St, Los Angeles, CA 90014",
        "latitude": 34.0426,
        "longitude": -118.2551,
        "drinks": ["Streetlevel Espresso", "Seabright Blend", "Flash Brew", "Matcha Latte"],
    },
    {
        "shopName": "Go Get Em Tiger",
        "address": "230 N Larchmont Blvd, Los Angeles, CA 90004",
        "latitude": 34.0735,
        "longitude": -118.3234,
        "drinks": ["Macchiato", "Almond Macadamia Latte", "Cold Brew", "Espresso Tonic"],
    },
    {
        "shopName": "Stumptown Coffee Roasters",
        "address": "806 S Santa Fe Ave, Los Angeles, CA 90021",
        "latitude": 34.0350,
        "longitude": -118.2345,
        "drinks": ["Hair Bender", "Holler Mountain", "Nitro Cold Brew", "Direct Trade Drip"],
    },
    {
        "shopName": "Dinosaur Coffee",
        "address": "4334 W Sunset Blvd, Los Angeles, CA 90029",
        "latitude": 34.0908,
        "longitude": -118.2832,
        "drinks": ["Drip Coffee", "Cortado", "Iced Latte", "Americano"],
    },
    {
        "shopName": "Cognoscenti Coffee",
        "address": "6114 Washington Blvd, Culver City, CA 90232",
        "latitude": 34.0244,
        "longitude": -118.3872,
        "drinks": ["Single Origin Espresso", "Pour Over", "Macchiato", "Cold Brew"],
    },
    {
        "shopName": "Goodboybob Coffee",
        "address": "2521 Main St, Santa Monica, CA 90405",
        "latitude": 34.0049,
        "longitude": -118.4917,
        "drinks": ["House Latte", "Espresso", "Iced Coffee", "Mocha"],
    },
    {
        "shopName": "Alfred Coffee",
        "address": "8428 Melrose Pl, Los Angeles, CA 90069",
        "latitude": 34.0836,
        "longitude": -118.3752,
        "drinks": ["Iced Vanilla Latte", "Almond Milk Cap", "Matcha Latte", "Cold Brew"],
    },
    {
        "shopName": "Copa Vida",
        "address": "70 S Raymond Ave, Pasadena, CA 91105",
        "latitude": 34.1442,
        "longitude": -118.1489,
        "drinks": ["Cortado", "Gibraltar", "Flash Cold Brew", "Oat Cappuccino"],
    },
    {
        "shopName": "Demitasse",
        "address": "135 S San Pedro St, Los Angeles, CA 90012",
        "latitude": 34.0478,
        "longitude": -118.2415,
        "drinks": ["Kyoto Cold Brew", "Lavender Latte", "Espresso Flight", "Matcha"],
    },
    {
        "shopName": "Menotti's Coffee Stop",
        "address": "56 Windward Ave, Venice, CA 90291",
        "latitude": 33.9885,
        "longitude": -118.4728,
        "drinks": ["Drip Coffee", "Espresso", "Iced Latte", "Americano"],
    },
    {
        "shopName": "Tierra Mia Coffee",
        "address": "1159 N Vermont Ave, Los Angeles, CA 90029",
        "latitude": 34.0908,
        "longitude": -118.2919,
        "drinks": ["Horchata Latte", "Cafe de Olla", "Mazapan Latte", "Cold Brew"],
    },
    {
        "shopName": "Endorffeine Coffee",
        "address": "727 N Broadway, Los Angeles, CA 90012",
        "latitude": 34.0614,
        "longitude": -118.2400,
        "drinks": ["Vietnamese Coffee", "Thai Tea Latte", "Espresso", "Ube Latte"],
    },
    {
        "shopName": "Document Coffee Bar",
        "address": "3850 Wilshire Blvd, Los Angeles, CA 90010",
        "latitude": 34.0616,
        "longitude": -118.3093,
        "drinks": ["Pour Over", "Flat White", "Iced Americano", "Seasonal Latte"],
    },
]

# Portland, Oregon coffee shops
SAMPLE_PORTLAND_COFFEE_SHOPS = [
    {
        "shopName": "Stumptown Coffee Roasters",
        "address": "128 SW 3rd Ave, Portland, OR 97204",
        "latitude": 45.5209,
        "longitude": -122.6739,
        "drinks": ["Hair Bender", "Holler Mountain", "Cold Brew", "Nitro"],
    },
    {
        "shopName": "Coava Coffee Roasters",
        "address": "1015 SE Main St, Portland, OR 97214",
        "latitude": 45.5151,
        "longitude": -122.6538,
        "drinks": ["Kilenso", "House Espresso", "Pour Over Flight", "Cortado"],
    },
    {
        "shopName": "Heart Coffee Roasters",
        "address": "2211 E Burnside St, Portland, OR 97214",
        "latitude": 45.5228,
        "longitude": -122.6432,
        "drinks": ["Stereo Blend", "Single Origin", "Cappuccino", "Cold Brew"],
    },
    {
        "shopName": "Proud Mary Coffee",
        "address": "2012 NE Alberta St, Portland, OR 97211",
        "latitude": 45.5590,
        "longitude": -122.6432,
        "drinks": ["The Aunty", "Filter Coffee", "Magic", "Flat White"],
    },
    {
        "shopName": "Case Study Coffee",
        "address": "1422 NE Alberta St, Portland, OR 97211",
        "latitude": 45.5590,
        "longitude": -122.6508,
        "drinks": ["Drip Coffee", "Espresso", "Mocha", "Chai Latte"],
    },
    {
        "shopName": "Water Avenue Coffee",
        "address": "1028 SE Water Ave, Portland, OR 97214",
        "latitude": 45.5133,
        "longitude": -122.6627,
        "drinks": ["El Burro", "Americano", "Pour Over", "Iced Latte"],
    },
    {
        "shopName": "Never Coffee",
        "address": "1308 SE Hawthorne Blvd, Portland, OR 97214",
        "latitude": 45.5118,
        "longitude": -122.6530,
        "drinks": ["Cortado", "Oat Latte", "Cold Brew", "Espresso"],
    },
    {
        "shopName": "Good Coffee",
        "address": "2370 NW Thurman St, Portland, OR 97210",
        "latitude": 45.5364,
        "longitude": -122.7038,
        "drinks": ["Cascara Fizz", "Drip", "Macchiato", "Latte"],
    },
    {
        "shopName": "Deadstock Coffee",
        "address": "408 NW Couch St, Portland, OR 97209",
        "latitude": 45.5242,
        "longitude": -122.6752,
        "drinks": ["Jordan 1 Latte", "Dunk Mocha", "Drip", "Cold Brew"],
    },
    {
        "shopName": "Upper Left Roasters",
        "address": "200 NE 28th Ave, Portland, OR 97232",
        "latitude": 45.5285,
        "longitude": -122.6365,
        "drinks": ["House Blend", "Single Origin", "Cappuccino", "Pour Over"],
    },
    {
        "shopName": "Extracto Coffee Roasters",
        "address": "2921 NE Killingsworth St, Portland, OR 97211",
        "latitude": 45.5636,
        "longitude": -122.6371,
        "drinks": ["Ethiopia", "Colombia", "Espresso", "Iced Coffee"],
    },
    {
        "shopName": "Either/Or",
        "address": "4003 N Mississippi Ave, Portland, OR 97227",
        "latitude": 45.5527,
        "longitude": -122.6759,
        "drinks": ["Batch Brew", "Cortado", "Oat Cap", "Cold Brew"],
    },
    {
        "shopName": "Roseline Coffee",
        "address": "1429 NW 14th Ave, Portland, OR 97209",
        "latitude": 45.5319,
        "longitude": -122.6873,
        "drinks": ["Comfort Zone", "Single Origin", "Americano", "Latte"],
    },
    {
        "shopName": "Push X Pull Coffee",
        "address": "4518 SE Hawthorne Blvd, Portland, OR 97215",
        "latitude": 45.5118,
        "longitude": -122.6183,
        "drinks": ["Espresso", "Macchiato", "Drip", "Oat Latte"],
    },
    {
        "shopName": "Sterling Coffee Roasters",
        "address": "417 NW 21st Ave, Portland, OR 97209",
        "latitude": 45.5271,
        "longitude": -122.6941,
        "drinks": ["Single Origin", "House Espresso", "Cold Brew", "Cortado"],
    },
]

# New York City coffee shops
SAMPLE_NYC_COFFEE_SHOPS = [
    {
        "shopName": "Stumptown Coffee Roasters",
        "address": "30 W 8th St, New York, NY 10011",
        "latitude": 40.7324,
        "longitude": -73.9967,
        "drinks": ["Hair Bender", "Cold Brew", "Holler Mountain Drip", "Nitro"],
    },
    {
        "shopName": "Blue Bottle Coffee",
        "address": "450 W 15th St, New York, NY 10011",
        "latitude": 40.7426,
        "longitude": -74.0065,
        "drinks": ["New Orleans Iced", "Gibraltar", "Pour Over", "Cappuccino"],
    },
    {
        "shopName": "La Colombe Coffee",
        "address": "400 Lafayette St, New York, NY 10003",
        "latitude": 40.7292,
        "longitude": -73.9925,
        "drinks": ["Draft Latte", "Corsica Blend", "Pure Black Cold Brew", "Oat Latte"],
    },
    {
        "shopName": "Cafe Grumpy",
        "address": "224 W 20th St, New York, NY 10011",
        "latitude": 40.7421,
        "longitude": -73.9984,
        "drinks": ["Heartbreaker Espresso", "Drip Coffee", "Iced Latte", "Cortado"],
    },
    {
        "shopName": "Devocion",
        "address": "69 Grand St, Brooklyn, NY 11249",
        "latitude": 40.7142,
        "longitude": -73.9650,
        "drinks": ["Colombian Single Origin", "Cold Brew", "Latte", "Espresso"],
    },
    {
        "shopName": "Sey Coffee",
        "address": "18 Grattan St, Brooklyn, NY 11206",
        "latitude": 40.7068,
        "longitude": -73.9378,
        "drinks": ["Filter Coffee", "Espresso", "Oat Cortado", "Cold Brew"],
    },
    {
        "shopName": "Partners Coffee",
        "address": "125 N 6th St, Brooklyn, NY 11249",
        "latitude": 40.7178,
        "longitude": -73.9597,
        "drinks": ["House Espresso", "Drip", "Iced Latte", "Flat White"],
    },
    {
        "shopName": "Variety Coffee Roasters",
        "address": "368 Graham Ave, Brooklyn, NY 11211",
        "latitude": 40.7144,
        "longitude": -73.9447,
        "drinks": ["Sweet Spot", "Single Origin", "Iced Coffee", "Americano"],
    },
    {
        "shopName": "Birch Coffee",
        "address": "5 E 27th St, New York, NY 10016",
        "latitude": 40.7438,
        "longitude": -73.9871,
        "drinks": ["House Blend", "Latte", "Cold Brew", "Macchiato"],
    },
    {
        "shopName": "Abraco",
        "address": "81 E 7th St, New York, NY 10003",
        "latitude": 40.7270,
        "longitude": -73.9843,
        "drinks": ["Espresso", "Olive Oil Cake", "Cortado", "Drip"],
    },
    {
        "shopName": "Cha Cha Matcha",
        "address": "373 Broome St, New York, NY 10013",
        "latitude": 40.7211,
        "longitude": -73.9971,
        "drinks": ["Matcha Latte", "Coconut Matcha", "Espresso", "Hojicha"],
    },
    {
        "shopName": "Felix Roasting Co.",
        "address": "450 Park Ave S, New York, NY 10016",
        "latitude": 40.7449,
        "longitude": -73.9825,
        "drinks": ["Espresso", "Cappuccino", "Rose Latte", "Pour Over"],
    },
    {
        "shopName": "Toby's Estate Coffee",
        "address": "125 N 6th St, Brooklyn, NY 11249",
        "latitude": 40.7178,
        "longitude": -73.9597,
        "drinks": ["Woolloomooloo Blend", "Flat White", "Cold Brew", "Single Origin"],
    },
    {
        "shopName": "Blank Street Coffee",
        "address": "177 Mott St, New York, NY 10012",
        "latitude": 40.7214,
        "longitude": -73.9954,
        "drinks": ["Iced Latte", "Matcha", "Drip Coffee", "Oat Cappuccino"],
    },
    {
        "shopName": "Think Coffee",
        "address": "248 Mercer St, New York, NY 10012",
        "latitude": 40.7291,
        "longitude": -73.9969,
        "drinks": ["Fair Trade Drip", "Espresso", "Mocha", "Iced Coffee"],
    },
]

# Tokyo, Japan coffee shops
SAMPLE_TOKYO_COFFEE_SHOPS = [
    {
        "shopName": "Blue Bottle Coffee Aoyama",
        "address": "3-13-14 Minamiaoyama, Minato, Tokyo 107-0062",
        "latitude": 35.6656,
        "longitude": 139.7144,
        "drinks": ["New Orleans Iced", "Single Origin Pour Over", "Latte", "Espresso"],
    },
    {
        "shopName": "Fuglen Tokyo",
        "address": "1-16-11 Tomigaya, Shibuya, Tokyo 151-0063",
        "latitude": 35.6673,
        "longitude": 139.6881,
        "drinks": ["Aeropress", "Cold Brew", "Flat White", "Filter Coffee"],
    },
    {
        "shopName": "Onibus Coffee Nakameguro",
        "address": "2-14-1 Kamimeguro, Meguro, Tokyo 153-0051",
        "latitude": 35.6442,
        "longitude": 139.6988,
        "drinks": ["Espresso", "Latte", "Pour Over", "Affogato"],
    },
    {
        "shopName": "Koffee Mameya",
        "address": "4-15-3 Jingumae, Shibuya, Tokyo 150-0001",
        "latitude": 35.6706,
        "longitude": 139.7074,
        "drinks": ["Single Origin", "Hand Drip", "Espresso", "Tasting Flight"],
    },
    {
        "shopName": "Streamer Coffee Company",
        "address": "1-20-28 Shibuya, Shibuya, Tokyo 150-0002",
        "latitude": 35.6594,
        "longitude": 139.7032,
        "drinks": ["Streamer Latte", "Military Latte", "Flat White", "Americano"],
    },
    {
        "shopName": "Sarutahiko Coffee",
        "address": "1-6-6 Ebisu, Shibuya, Tokyo 150-0013",
        "latitude": 35.6467,
        "longitude": 139.7103,
        "drinks": ["House Blend", "Single Origin", "Cafe Latte", "Cold Brew"],
    },
    {
        "shopName": "Glitch Coffee & Roasters",
        "address": "3-16 Kanda Nishikicho, Chiyoda, Tokyo 101-0054",
        "latitude": 35.6933,
        "longitude": 139.7589,
        "drinks": ["Filter Coffee", "Espresso", "Cortado", "Iced Coffee"],
    },
    {
        "shopName": "Omotesando Koffee",
        "address": "4-15-3 Jingumae, Shibuya, Tokyo 150-0001",
        "latitude": 35.6707,
        "longitude": 139.7073,
        "drinks": ["Koffee", "Latte", "Cappuccino", "Macchiato"],
    },
    {
        "shopName": "Verve Coffee Roasters Tokyo",
        "address": "5-3-27 Minamiaoyama, Minato, Tokyo 107-0062",
        "latitude": 35.6616,
        "longitude": 139.7128,
        "drinks": ["Streetlevel Espresso", "Flash Brew", "Latte", "Seabright Blend"],
    },
    {
        "shopName": "About Life Coffee Brewers",
        "address": "1-19-8 Dogenzaka, Shibuya, Tokyo 150-0043",
        "latitude": 35.6583,
        "longitude": 139.6947,
        "drinks": ["Hand Drip", "Espresso", "Cafe Latte", "Cold Brew"],
    },
    {
        "shopName": "Bear Pond Espresso",
        "address": "2-36-12 Kitazawa, Setagaya, Tokyo 155-0031",
        "latitude": 35.6619,
        "longitude": 139.6684,
        "drinks": ["Angel Stain", "Dirty Chai", "Espresso", "Latte"],
    },
    {
        "shopName": "Switch Coffee Tokyo",
        "address": "1-17-23 Meguro, Meguro, Tokyo 153-0063",
        "latitude": 35.6339,
        "longitude": 139.7159,
        "drinks": ["Filter", "Espresso", "Flat White", "Batch Brew"],
    },
    {
        "shopName": "Allpress Espresso Tokyo",
        "address": "3-7-2 Higashishimbashi, Minato, Tokyo 105-0021",
        "latitude": 35.6594,
        "longitude": 139.7582,
        "drinks": ["Flat White", "Long Black", "Espresso", "Iced Latte"],
    },
    {
        "shopName": "Cafe de L'Ambre",
        "address": "8-10-15 Ginza, Chuo, Tokyo 104-0061",
        "latitude": 35.6696,
        "longitude": 139.7632,
        "drinks": ["Aged Coffee", "Blend No. 7", "Nel Drip", "Iced Coffee"],
    },
    {
        "shopName": "Turret Coffee",
        "address": "2-12-10 Tsukiji, Chuo, Tokyo 104-0045",
        "latitude": 35.6673,
        "longitude": 139.7709,
        "drinks": ["Latte", "Cappuccino", "Mocha", "Americano"],
    },
]

# Indore, India coffee shops
SAMPLE_INDORE_COFFEE_SHOPS = [
    {
        "shopName": "Cafe Terazza",
        "address": "16/1, South Tukoganj, Indore, MP 452001",
        "latitude": 22.7195,
        "longitude": 75.8577,
        "drinks": ["Cappuccino", "Cold Coffee", "Hazelnut Latte", "Espresso"],
    },
    {
        "shopName": "Mocha - The Coffee Bar",
        "address": "7, Navlakha Square, Indore, MP 452001",
        "latitude": 22.7245,
        "longitude": 75.8720,
        "drinks": ["Mocha", "Irish Coffee", "Caramel Latte", "Frappe"],
    },
    {
        "shopName": "Cafe 42",
        "address": "42, Sapna Sangeeta Road, Indore, MP 452001",
        "latitude": 22.7196,
        "longitude": 75.8805,
        "drinks": ["Filter Coffee", "Americano", "Cold Brew", "Tiramisu Latte"],
    },
    {
        "shopName": "The Mango Tree Cafe",
        "address": "Vijay Nagar, Indore, MP 452010",
        "latitude": 22.7533,
        "longitude": 75.8937,
        "drinks": ["South Indian Filter Coffee", "Latte", "Espresso", "Iced Coffee"],
    },
    {
        "shopName": "Sayaji Cafe",
        "address": "H/1, Scheme No. 54, Vijay Nagar, Indore, MP 452010",
        "latitude": 22.7512,
        "longitude": 75.8958,
        "drinks": ["Cappuccino", "Affogato", "Mocha", "Espresso Shot"],
    },
    {
        "shopName": "Bake n Shake",
        "address": "South Tukoganj Main Road, Indore, MP 452001",
        "latitude": 22.7181,
        "longitude": 75.8581,
        "drinks": ["Cold Coffee", "Nutella Shake", "Espresso", "Frappe"],
    },
    {
        "shopName": "Warehouse Cafe",
        "address": "6, New Palasia, Indore, MP 452001",
        "latitude": 22.7232,
        "longitude": 75.8693,
        "drinks": ["Caramel Macchiato", "Latte", "Flat White", "Pour Over"],
    },
    {
        "shopName": "Bikaner Misthan Bhandar",
        "address": "Sarafa Bazaar, Indore, MP 452002",
        "latitude": 22.7179,
        "longitude": 75.8559,
        "drinks": ["Masala Chai", "Filter Coffee", "Ginger Coffee", "Cardamom Coffee"],
    },
    {
        "shopName": "Cafe Infinitea",
        "address": "Bhawarkuan Square, Indore, MP 452001",
        "latitude": 22.7295,
        "longitude": 75.8428,
        "drinks": ["Cappuccino", "Iced Latte", "Mocha Frappe", "Espresso"],
    },
    {
        "shopName": "The Rolling Jar",
        "address": "Scheme 78, Vijay Nagar, Indore, MP 452010",
        "latitude": 22.7518,
        "longitude": 75.8952,
        "drinks": ["Cold Brew", "Vanilla Latte", "Caramel Macchiato", "Irish Coffee"],
    },
    {
        "shopName": "Third Wave Coffee",
        "address": "DB Mall, Indore, MP 452001",
        "latitude": 22.7240,
        "longitude": 75.8565,
        "drinks": ["Pour Over", "Single Origin", "Cortado", "Oat Latte"],
    },
    {
        "shopName": "Starbucks Indore",
        "address": "Phoenix Citadel Mall, Indore, MP 452010",
        "latitude": 22.7470,
        "longitude": 75.8920,
        "drinks": ["Pike Place Roast", "Caramel Macchiato", "Java Chip Frappe", "Latte"],
    },
    {
        "shopName": "Chai Sutta Bar",
        "address": "MG Road, Indore, MP 452001",
        "latitude": 22.7175,
        "longitude": 75.8576,
        "drinks": ["Kulhad Chai", "Tandoori Chai", "Filter Coffee", "Cold Coffee"],
    },
    {
        "shopName": "Blue Tokai Coffee",
        "address": "Vijay Nagar Square, Indore, MP 452010",
        "latitude": 22.7508,
        "longitude": 75.8945,
        "drinks": ["Vienna Roast", "Single Estate", "Cold Brew", "Cappuccino"],
    },
    {
        "shopName": "Madras Coffee House",
        "address": "Race Course Road, Indore, MP 452003",
        "latitude": 22.7283,
        "longitude": 75.8472,
        "drinks": ["Filter Kaapi", "Madras Coffee", "Espresso", "Latte"],
    },
]

SAMPLE_NOTES = [
    "Great atmosphere, will definitely come back!",
    "The barista recommended this drink and it was perfect.",
    "A bit crowded but worth the wait.",
    "Love the industrial decor here.",
    "Best espresso I've had in a while.",
    "Good WiFi, perfect for working remotely.",
    "The pastries here are amazing too!",
    "Friendly staff, made my morning better.",
    "Tried something new today - no regrets!",
    "A hidden gem in the neighborhood.",
    "The pour over was exceptional.",
    "Nice outdoor seating area.",
    "A bit pricey but quality is top notch.",
    "My new go-to spot for morning coffee.",
    "",  # Some visits have no notes
    "",
    "",
]

WISHLIST_NOTES = [
    "Heard great things about this place!",
    "Recommended by a friend.",
    "Saw on Instagram, looks amazing.",
    "Featured in Seattle Met magazine.",
    "Want to try their signature drink.",
    "Great reviews online.",
    "Love the aesthetic from photos.",
    "On my list for a while now.",
    "Perfect for a weekend visit.",
    "Need to check out their pastries.",
    "",  # Some wishlist items have no notes
    "",
    "",
]


class FirebaseAuthClient:
    """Client for Firebase Authentication REST API"""

    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://identitytoolkit.googleapis.com/v1"

    def sign_up(self, email: str, password: str) -> dict:
        """Create a new user account"""
        url = f"{self.base_url}/accounts:signUp?key={self.api_key}"
        payload = {
            "email": email,
            "password": password,
            "returnSecureToken": True,
        }
        response = requests.post(url, json=payload)
        if response.status_code != 200:
            error = response.json().get("error", {})
            raise Exception(f"Sign up failed: {error.get('message', 'Unknown error')}")
        return response.json()

    def sign_in(self, email: str, password: str) -> dict:
        """Sign in with email and password"""
        url = f"{self.base_url}/accounts:signInWithPassword?key={self.api_key}"
        payload = {
            "email": email,
            "password": password,
            "returnSecureToken": True,
        }
        response = requests.post(url, json=payload)
        if response.status_code != 200:
            error = response.json().get("error", {})
            raise Exception(f"Sign in failed: {error.get('message', 'Unknown error')}")
        return response.json()

    def sign_in_or_create(self, email: str, password: str) -> dict:
        """Try to sign in, create account if it doesn't exist"""
        try:
            print(f"Attempting to sign in as {email}...")
            result = self.sign_in(email, password)
            print("Successfully signed in to existing account.")
            return result
        except Exception as e:
            # Handle various "user not found" error messages from Firebase
            error_str = str(e)
            if any(err in error_str for err in ["EMAIL_NOT_FOUND", "INVALID_LOGIN_CREDENTIALS", "user-not-found"]):
                print(f"Account not found. Creating new account for {email}...")
                result = self.sign_up(email, password)
                print("Successfully created new account.")
                return result
            raise


class FirestoreClient:
    """Client for Firestore REST API"""

    def __init__(self, project_id: str, id_token: str):
        self.project_id = project_id
        self.id_token = id_token
        self.base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents"

    def _headers(self) -> dict:
        return {
            "Authorization": f"Bearer {self.id_token}",
            "Content-Type": "application/json",
        }

    def _to_firestore_value(self, value):
        """Convert Python value to Firestore value format"""
        if value is None:
            return {"nullValue": None}
        elif isinstance(value, bool):
            return {"booleanValue": value}
        elif isinstance(value, int):
            return {"integerValue": str(value)}
        elif isinstance(value, float):
            return {"doubleValue": value}
        elif isinstance(value, str):
            return {"stringValue": value}
        elif isinstance(value, datetime):
            return {"timestampValue": value.isoformat() + "Z"}
        elif isinstance(value, list):
            return {"arrayValue": {"values": [self._to_firestore_value(v) for v in value]}}
        elif isinstance(value, dict):
            return {"mapValue": {"fields": {k: self._to_firestore_value(v) for k, v in value.items()}}}
        else:
            return {"stringValue": str(value)}

    def create_document(self, collection_path: str, document_id: str, data: dict) -> dict:
        """Create a document in Firestore"""
        url = f"{self.base_url}/{collection_path}?documentId={document_id}"
        fields = {k: self._to_firestore_value(v) for k, v in data.items()}
        payload = {"fields": fields}

        response = requests.post(url, headers=self._headers(), json=payload)
        if response.status_code not in [200, 201]:
            error = response.json().get("error", {})
            raise Exception(f"Create document failed: {error.get('message', response.text)}")
        return response.json()

    def update_document(self, document_path: str, data: dict) -> dict:
        """Update or create a document in Firestore"""
        url = f"{self.base_url}/{document_path}"
        fields = {k: self._to_firestore_value(v) for k, v in data.items()}
        payload = {"fields": fields}

        response = requests.patch(url, headers=self._headers(), json=payload)
        if response.status_code not in [200, 201]:
            error = response.json().get("error", {})
            raise Exception(f"Update document failed: {error.get('message', response.text)}")
        return response.json()

    def delete_document(self, document_path: str) -> None:
        """Delete a document from Firestore"""
        url = f"{self.base_url}/{document_path}"
        response = requests.delete(url, headers=self._headers())
        if response.status_code not in [200, 204]:
            error = response.json().get("error", {})
            raise Exception(f"Delete document failed: {error.get('message', response.text)}")

    def list_documents(self, collection_path: str) -> list:
        """List all documents in a collection"""
        url = f"{self.base_url}/{collection_path}"
        documents = []
        page_token = None

        while True:
            params = {"pageSize": 100}
            if page_token:
                params["pageToken"] = page_token

            response = requests.get(url, headers=self._headers(), params=params)
            if response.status_code != 200:
                error = response.json().get("error", {})
                raise Exception(f"List documents failed: {error.get('message', response.text)}")

            result = response.json()
            documents.extend(result.get("documents", []))

            page_token = result.get("nextPageToken")
            if not page_token:
                break

        return documents


def generate_visit(user_id: str, shops_list: list, days_ago: Optional[int] = None) -> dict:
    """Generate a random coffee shop visit"""
    shop = random.choice(shops_list)

    # Generate a random date within the last 90 days if not specified
    if days_ago is None:
        days_ago = random.randint(0, 90)
    visit_date = datetime.now() - timedelta(days=days_ago)

    # Random rating between 2.5 and 5.0 in 0.5 increments (weighted towards higher)
    rating_options = [2.5, 3.0, 3.5, 4.0, 4.0, 4.5, 4.5, 4.5, 5.0, 5.0]
    rating = random.choice(rating_options)

    # Random price between $3 and $12
    price = round(random.uniform(3.0, 12.0), 2)

    # Random 1-3 items ordered
    num_items = random.randint(1, 3)
    items_ordered = random.sample(shop["drinks"], min(num_items, len(shop["drinks"])))

    # Random notes (some visits have no notes)
    notes = random.choice(SAMPLE_NOTES)

    visit = {
        "id": str(uuid.uuid4()),
        "userId": user_id,
        "shopName": shop["shopName"],
        "address": shop["address"],
        "latitude": shop["latitude"],
        "longitude": shop["longitude"],
        "itemsOrdered": items_ordered,
        "rating": rating,
        "price": price,
        "dateVisited": visit_date,
    }

    # Only include notes if not empty
    if notes:
        visit["notes"] = notes

    return visit


def create_user_profile(firestore: FirestoreClient, user_id: str, email: str) -> None:
    """Create or update user profile in Firestore"""
    profile_data = {
        "id": user_id,
        "email": email,
        "subscriptionTier": "premium",  # Give test user premium for full testing
        "dateCreated": datetime.now(),
    }

    print(f"Creating/updating user profile for {email}...")
    firestore.update_document(f"users/{user_id}", profile_data)
    print("User profile created/updated successfully.")


def clear_existing_visits(firestore: FirestoreClient, user_id: str) -> int:
    """Delete all existing visits for a user"""
    print("Clearing existing visits...")
    collection_path = f"users/{user_id}/visits"

    try:
        documents = firestore.list_documents(collection_path)
        count = len(documents)

        for doc in documents:
            # Extract document path from full name
            doc_name = doc.get("name", "")
            doc_path = doc_name.split("/documents/")[-1] if "/documents/" in doc_name else None
            if doc_path:
                firestore.delete_document(doc_path)

        print(f"Deleted {count} existing visits.")
        return count
    except Exception as e:
        if "NOT_FOUND" in str(e):
            print("No existing visits found.")
            return 0
        raise


def seed_visits(firestore: FirestoreClient, user_id: str, num_visits: int, shops_list: list) -> int:
    """Create sample coffee shop visits"""
    print(f"\nSeeding {num_visits} coffee shop visits...")
    collection_path = f"users/{user_id}/visits"

    for i in range(num_visits):
        visit = generate_visit(user_id, shops_list)
        firestore.create_document(collection_path, visit["id"], visit)
        print(f"  Created visit {i + 1}/{num_visits}: {visit['shopName']} - {visit['itemsOrdered'][0]}")

    print(f"\nSuccessfully created {num_visits} visits!")
    return num_visits


def generate_wishlist_item(user_id: str, days_ago: Optional[int] = None) -> dict:
    """Generate a random wishlist item"""
    shop = random.choice(SAMPLE_WISHLIST_SHOPS)

    # Generate a random date within the last 30 days if not specified
    if days_ago is None:
        days_ago = random.randint(0, 30)
    date_added = datetime.now() - timedelta(days=days_ago)

    # Random notes (some wishlist items have no notes)
    notes = random.choice(WISHLIST_NOTES)

    item = {
        "id": str(uuid.uuid4()),
        "userId": user_id,
        "shopName": shop["shopName"],
        "address": shop["address"],
        "latitude": shop["latitude"],
        "longitude": shop["longitude"],
        "dateAdded": date_added,
    }

    # Only include notes if not empty
    if notes:
        item["notes"] = notes

    return item


def clear_existing_wishlist(firestore: FirestoreClient, user_id: str) -> int:
    """Delete all existing wishlist items for a user"""
    print("Clearing existing wishlist...")
    collection_path = f"users/{user_id}/wishlist"

    try:
        documents = firestore.list_documents(collection_path)
        count = len(documents)

        for doc in documents:
            # Extract document path from full name
            doc_name = doc.get("name", "")
            doc_path = doc_name.split("/documents/")[-1] if "/documents/" in doc_name else None
            if doc_path:
                firestore.delete_document(doc_path)

        print(f"Deleted {count} existing wishlist items.")
        return count
    except Exception as e:
        if "NOT_FOUND" in str(e):
            print("No existing wishlist items found.")
            return 0
        raise


def seed_wishlist(firestore: FirestoreClient, user_id: str, num_items: int) -> int:
    """Create sample wishlist items"""
    print(f"\nSeeding {num_items} wishlist items...")
    collection_path = f"users/{user_id}/wishlist"

    # Use unique shops to avoid duplicates
    shops_to_use = random.sample(SAMPLE_WISHLIST_SHOPS, min(num_items, len(SAMPLE_WISHLIST_SHOPS)))

    for i, shop in enumerate(shops_to_use):
        days_ago = random.randint(0, 30)
        date_added = datetime.now() - timedelta(days=days_ago)
        notes = random.choice(WISHLIST_NOTES)

        item = {
            "id": str(uuid.uuid4()),
            "userId": user_id,
            "shopName": shop["shopName"],
            "address": shop["address"],
            "latitude": shop["latitude"],
            "longitude": shop["longitude"],
            "dateAdded": date_added,
        }
        if notes:
            item["notes"] = notes

        firestore.create_document(collection_path, item["id"], item)
        print(f"  Created wishlist item {i + 1}/{len(shops_to_use)}: {shop['shopName']}")

    print(f"\nSuccessfully created {len(shops_to_use)} wishlist items!")
    return len(shops_to_use)


def main():
    parser = argparse.ArgumentParser(
        description="Seed test data for CoffeeNote app",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument(
        "--email",
        default="test@gmail.com",
        help="Test account email (default: test@gmail.com)",
    )
    parser.add_argument(
        "--password",
        default="testtest",
        help="Test account password (default: testtest)",
    )
    parser.add_argument(
        "--visits",
        type=int,
        default=15,
        help="Number of visits to create (default: 15)",
    )
    parser.add_argument(
        "--wishlist",
        type=int,
        default=5,
        help="Number of wishlist items to create (default: 5)",
    )
    parser.add_argument(
        "--city",
        choices=["seattle", "la", "portland", "nyc", "tokyo", "indore", "all"],
        default="all",
        help="City: seattle, la, portland, nyc, tokyo, indore, or all (default: all)",
    )
    parser.add_argument(
        "--clear",
        action="store_true",
        help="Clear all visits and wishlist items (no seeding)",
    )
    args = parser.parse_args()

    # Define city configurations
    all_cities = {
        "seattle": ("Seattle", SAMPLE_COFFEE_SHOPS),
        "la": ("Los Angeles", SAMPLE_LA_COFFEE_SHOPS),
        "portland": ("Portland", SAMPLE_PORTLAND_COFFEE_SHOPS),
        "nyc": ("New York City", SAMPLE_NYC_COFFEE_SHOPS),
        "tokyo": ("Tokyo", SAMPLE_TOKYO_COFFEE_SHOPS),
        "indore": ("Indore", SAMPLE_INDORE_COFFEE_SHOPS),
    }

    # Determine which cities to seed
    if args.city == "all":
        cities_to_seed = list(all_cities.keys())
        city_name = "All Cities"
        total_visits = args.visits * len(cities_to_seed)
    else:
        cities_to_seed = [args.city]
        city_name = all_cities[args.city][0]
        total_visits = args.visits

    print("=" * 60)
    print("CoffeeNote Test Data Seeder")
    print("=" * 60)
    print(f"\nProject: {FIREBASE_CONFIG['projectId']}")
    print(f"Test Account: {args.email}")
    print(f"City: {city_name}")
    print(f"Visits per City: {args.visits}")
    print(f"Total Visits: {total_visits}")
    print(f"Wishlist Items to Create: {args.wishlist}")
    print()

    # Authenticate
    auth_client = FirebaseAuthClient(FIREBASE_CONFIG["apiKey"])
    auth_result = auth_client.sign_in_or_create(args.email, args.password)

    user_id = auth_result["localId"]
    id_token = auth_result["idToken"]
    print(f"User ID: {user_id}")

    # Initialize Firestore client
    firestore = FirestoreClient(FIREBASE_CONFIG["projectId"], id_token)

    # Create/update user profile
    create_user_profile(firestore, user_id, args.email)

    # Clear existing data if requested
    if args.clear:
        clear_existing_visits(firestore, user_id)
        clear_existing_wishlist(firestore, user_id)
        print("\n" + "=" * 60)
        print("Data Cleared!")
        print("=" * 60)
        print(f"\nCleared all visits and wishlist items for {args.email}")
        print()
        return

    # Seed visits for each city
    for city_key in cities_to_seed:
        city_display_name, shops_list = all_cities[city_key]
        print(f"\n--- {city_display_name} ---")
        seed_visits(firestore, user_id, args.visits, shops_list)

    # Seed wishlist
    seed_wishlist(firestore, user_id, args.wishlist)

    print("\n" + "=" * 60)
    print("Test Data Seeding Complete!")
    print("=" * 60)
    print(f"\nYou can now log in to the app with:")
    print(f"  Email:    {args.email}")
    print(f"  Password: {args.password}")
    print()


if __name__ == "__main__":
    main()
