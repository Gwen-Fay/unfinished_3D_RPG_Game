# unfinished_3D_RPG_Game
An RPG Game I started working on in the godot game engine.
![screenshot](https://imgur.com/68j43Hw.png)

# About This Project
My goal with this project at the time was to make a RPG like
classic Super Nintendo titles, but in 3D. To make this project 
managable as a solo developer, my plan was to use a 3D tile grid.
All I would have to do when making a new level is create new textures
for the tiles, and place the tiles down to make a scene.

This was made before Godot Mono existed, so it's writen in GDScript.
When I stopped working on it, I had implimented 2 major parts to the RPG,
movemement and A* pathfinding on the tiles, and I created a dialogue system
that uses json files to store dialogue trees. I could have kept developing
this project, but I got distracted and so I abandoned this project before I
had designed combat for the RPG.

# 3D A* Path Finding
![Walking on bridge](https://i.postimg.cc/8CBq2kCy/3-D-Tile-Levels-Walk.gif)  
So how does this work? First, we need to have a way to know if it is possible 
to walk from the current space to an adjacent space. This is done as follows:
A valid space consists of a tile with 2 empty or null tiles above it.
If 2 valid spaces are adjacent in the X and Z coordinates, and are +-1 in the Y coordinate,
they are connected. This alows for characters to talk up and down hills and stairs. 
Note that the actual tile shape does not matter, that is just artistic choice.
Everything could be made out of half block slabs, and the pathfinding would be equivelent.
Also note that there can only exist one valid tile in each cardinal direction, if there 
existed a tile both diagonally north/down, and north/up, the north/down tile would not be a
valid spot, because it does not have 2 null tiles directly above it.

Given this, we can just impliment A* pathfinding with using a 3D heuristic function.
Here is an example Non Player Character (NPC):  
![NPC Wandering](https://i.postimg.cc/sD31qmJy/3-D-Tile-Levels-Walk2.gif)  
In this example, the NPC chooses a random destination, walks there, and then waits for a bit.

This A* pathfinding can be used to easily impliment party members, NPCs that follow the main character.
Each Party member is set to follow someone, and when that person leaves some radius, they pathfind towards
them untill they are within the radius again. You can easily set up a chain of party members, where
party member A follows member B, who follows the main character. The only problem with this system, is if
you walk along a 1 tile pathway, the player could trap themselves because party members will not want to move away.
To fix this, I have it set so that if an NPC is following someone, they do not collide with other NPCs or the player.

![NPC Party Members](https://i.postimg.cc/632wD28d/A-star-Party-Members.gif)  

# Json Dialogue Trees
When I was working on this in my free time, I realized I can not spend too much time implimenting a feature if I wanted
to actually make an RPG game. So when designing the dialogue system, I needed an easy way to load a tree structure.
The most obvious way for me to impliment this is with json. Json Arrays would contain objects that represent one dialogue
screen, and if a choice happened, those objects would contain more arrays. So in GDScipt I needed a stack,
and every time a dialogue choice happened, I would push a dialogue array on the stack. When I was finished playing a dialogue, it would be
popped off and the next array would be processed. With this feature and with the implimentation saving and checking variables, this dialogue system
could do anything I wanted it to.

Here is an example dialogue and it's json file:  
![Dialogue with the Sign](https://i.postimg.cc/ZqqyvcQ4/Sign-Dialogue2.gif)  
And here is the code for that dialogue:   
```json
[
    {"name":"Sign", "face":"norm","text":"Hi this is the tutorial."},
    {"name":"Sign", "face":"norm","text":"Well, more acurately, this is a development test. I have no idea if any of this stuff will work."},
    {"effect":"angry"},
    {"name":"Sign", "face":"angry","text":"SO DON'T BREAK ANYTHING!!!"},
    {"name":"Sign", "face":"norm","text":"Do you understand?"},
    {"choice":["Yes.","No."],
    "0":[
        {"name":"Sign", "face":"norm","text":"Good."},
        {"name":"Sign", "face":"norm","text":"I'm glad that we understand eachother"}
        ],
    "1":[
        {"name":"Sign", "face":"angry","text":"I HATE YOU!!!"}
        ]
    },
    {"name":"Sign", "face":"norm","text":"Goodbye."},
    
    {"if":"2nd time sign 1",
        "t":[
            {"name":"Sign", "face":"norm","text":"..."},
            {"name":"Sign", "face":"norm","text":"So why did you have to go and waste your time checking this sign again?"}
            ],
    },
    {"set true":"2nd time sign 1"}
]
```
