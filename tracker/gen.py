#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import random
import sys
#from faker import Faker


#fake = Faker()

gender = ["Male", "Female"]
city = ["Moscow", "St. Petersburg", "Kazan", "Krasnodar", "Ekaterinburg", "Ufa", "Omsk", "Sochi"]
preference = ["Male", "Female", "Not matter"]
rang_cs = ["Silver", "Gold nova", "Master Guardian", "Legendary Eagle", "Supreme", "Global"]
rang_dota = ["Herald", "Guardian", "Crusader", "Archon", "Legend", "Ancient", "Divine", "Immortal"]
rang_valorant = ["Iron", "Bronze", "Silver", "Gold", "Platinum", "Diamond", "Ascendant", "Immortal", "Radiant"]
favrole = ["Mid", "Carry", "Hardlane", "Semi-support", "Support"]
favhero = ["Pudge", "Invoker", "Bristleback", "Axe", "Rikki", "Monkey king", "Weaver", "Techies", "Warlock", "Arc warden", "Wraith king", "Phantom lancer", "Witch doctor", "Crystall maiden", "Jakiro"]
favagent = ["Viper", "Phoenix", "Raze", "Neon", "Jett", "Harbor", "Omen", "Skye", "Breach", "Kayo", "Sage", "Cypher"]

def users(n):
    f = open("users.txt", "w")
    for i in range(n):
        f.write(f'{i + 1}; {fake.first_name()}; {fake.last_name()}; {random.randint(14, 25)}; {gender[random.randint(0, 1)]}; {fake.phone_number()}')
        f.write("\n")
    f.close()


def forms(n):
    f = open("forms.txt", "w")
    for i in range(n):
        f.write(f'{i + 1}; {fake.lexify(text="??????")}; Russia; {city[random.randint(0, 7)]}; {preference[random.randint(0, 2)]}; Hello, i want to find friends to play games together')
        f.write("\n")
    f.close()


def cs(n):
    f = open("cs.txt", "w")
    for i in range(n):
        f.write(f'{i + 1}; {rang_cs[random.randint(0, 5)]}; {random.randint(10, 90)}; {random.randint(0, 1)},{random.randint(0, 9)}{random.randint(0, 9)}; {random.randint(5, 100)}%; {random.randint(10, 3000)}')
        f.write("\n")
    f.close()


def dota(n):
    f = open("dota.txt", "w")
    for i in range(n):
        f.write(f'{i + 1}; {rang_dota[random.randint(0, 5)]}; {random.randint(10, 90)}; {random.randint(0, 30)}; {favrole[random.randint(0, 4)]}; {favhero[random.randint(0, 14)]}')
        f.write("\n")
    f.close()


def valorant(n):
    f = open("valorant.txt", "w")
    for i in range(n):
        f.write(f'{i + 1}; {rang_valorant[random.randint(0, 8)]}; {random.randint(10, 90)}; {random.randint(0, 1)},{random.randint(0, 9)}{random.randint(0, 9)}; {random.randint(5, 100)}%; {random.randint(10, 3000)}')
        f.write("\n")
    f.close()

def id_table(n):
    f = open("id_table.txt", "w")
    for i in range(n):
        f.write(f'{i + 1}; {i + 1}; {i + 1}; {i + 1}; {i + 1}; {i + 1}')
        f.write("\n")
    f.close()

if __name__ == "__main__":
    #users(1000)
    #forms(1000)
    #cs(1000)
    #dota(1000)
    #valorant(1000)
    id_table(1000)
