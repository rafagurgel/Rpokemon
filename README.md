# Pokémon Analysis in R

An useless application to view Pokemon stats between the generation games. The layout is made to look casual (not recommended in a presentation or other applications).

I hope you already know what is a Pokémon, if you don't I strongly recommend you to watch the anime or play a game (any from a Nintendo portable console, or, maybe Pokémon GO for mobile but this one it's not so cool as the others).

The series consists in 7 Generations from 1996 to 2017, each one introducing new Pokémons.
They have the following Attributes with values from 1 to 255
- HP
- Attack
- Defense
- Special Attack
- Special Defense
- Speed

They are also divided in Types, being in 1 or 2 types of the following classes:

- Bug
- Dark
- Dragon
- Electric
- Fairy
- Fighting
- Fire
- Flying
- Ghost
- Grass
- Ground
- Ice
- Normal
- Poison
- Psychic
- Rock
- Steel
- Water

All data is collected from [Serebii](https://www.serebii.net) and saved in a .csv format in order to reduce the computational load in the server. The (serebii.R file)[https://raw.githubusercontent.com/rafagurgel/Rpokemon/master/serebii.R] performs this calculations.

There are 5 functional tabs and 1 tab with informations.

### Generations Comparison
You select two generations and a interactive density plot (from plotly) is displayed showing the distribution of a chosen attribute over the selected generations.

### Generations Progression
In this tab is possible to choose one attribute and see this attribute progression over the generations (boxplot format). It also performs a linear fit.
In this tab is possible to "filter" some Pokémon Types, or select only a desired value. You must keep at least one Type selected.

### Types Comparision
This tab compares two selected Pokémon Types and you can filter it by Generations. You must keep at least one Generation selected.

### Cluster Analysis
The Pokémon Data from a selected Generation is clusterized and displayed in dendogram format.

### Dataset
This tab shows the full dataset. There are typical interactions common in html tables.
