# Explanation

1. Zorg voor een verse AdventureWorksLT2017
1. Voer de stappen in het data feed bestand uit
1. Ga naar de demo file en voer de stappen uit
1. Schrijf op het bord
    - workload 1: 6x met index
    - workload 2: 4x
    - workload 1: 5x zonder index

---

1. Ga naar de QueryStore en leg de 7 beschikbare categorieën kort uit:

    - **Overall Resource Consumption**\
Queries die de meeste resources (CPU, I/O, geheugen) gebruiken
    - **Top Resource Consuming Queries**\
De queries die het meeste verbruiken binnen een bepaalde periode
    - **Regressed Queries**\
Queries die slechter zijn gaan presteren na een wijziging
    - **Queries with Forced Plans**\
Queries waarvoor een specifiek uitvoeringsplan is afgedwongen
    - **Queries With High Variation**\
Queries waarvan de uitvoeringstijd of resourcegebruik sterk varieert (kan wijzen op inconsistentie in plannen of data)
    - **Query Wait Statistics**\
Welke queries wachten het meeste op resources (zoals locks, I/O, CPU) Hiermee kun je bottlenecks in de database identificeren
    - **Tracked Queries**\
Dit zijn queries die je expliciet volgt in de Query Store, bijvoorbeeld omdat ze belangrijk zijn voor je applicatie of omdat je hun prestaties wilt monitoren

2. Ga naar de Top Resource Consuming Queries
    - Links staan de queries, rechts de plannen (klink links een query aan)
    - Het lijkt alsof 1 veel langer duurde maar dat komt door de **Total Duration**. Wijzig dit in **Avg Duration** en dan wordt het verschil kleiner. Toch is er nog steeds een verschil, waarom??
    De schaalverdeling is (niet meteen duidelijk) verkleind!
    - Laat **Avg** staan, en toon wat andere metrics
      Bij **CPU Time** zijn de rollen omgedraaid!
    - Waarom presteer het tweede plan beter qua **Avg Duration**??
      Parallellisme, dat is hier op 1 lokale machine natuurlijk fijn, maar dat is in de praktijk waar meerdere queries tegelijkertijd moeten kunnen draaien, niet wenselijk
    - Er wordt bij het tweede plan een suggestie gegeven om een index te maken. Wat is dat voor index? (Merk op dat er in de `INCLUDE` 2 velden worden genoemd)



