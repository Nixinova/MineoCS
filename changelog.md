# Mineo Version History

## Alpha 0.3.0
*23/03/2019 17:23*
- Added a workbench found inside the spawn building
- Added a crafting menu, opened using the workbench
- A quarry can be crafted for 32 stone
- The quarry no longer destroys mined blocks, as it caused massive lagspikes
- Mined blocks now display with a number on-screen

## Alpha 0.2.4
*17/03/2019 18:34*
- Blocks now appear on the bottom of the screen when mined

## Alpha 0.2.3
*10/03/2019 17:39*
- Quarry now mines blocks 1 by 1

## Alpha 0.2.2
*10/03/2019 10:17*
- Added a quarry
- Exiting to the main menu no longer resets the world

## Alpha 0.2.1
*10/03/2019 08:57*
- Changed lock angle to 90 degrees up and down
- Added foundations to ship
- Moved camera down half a block
- Fixed trees and grass generating inside ship

## Alpha 0.2.0
*09/03/2019 20:31*
- Sped up player by 25%
- Made player 1/2 block taller
- Fixed coordinates XZ not halving
- Added ship at spawn

## Alpha 0.1.5
*03/03/2019 19:46*
- Trees can now generate anywhere inside a chunk
- Fixed camera clipping through blocks above the player
- Fixed floating trees
- Trees now have dirt under them

## Alpha 0.1.4
*03/03/2019 19:24*
- Blocks now take up one full world-grid-block instead of 1/4
- The player is now 2 blocks tall
- Rounded coordinates to 1dp
- Press B to hide/show coordinates
- Changed view locking from 45 degrees to 60 degrees up and down

## Alpha 0.1.3
*28/02/2019 17:03*
- Removed crosshair
- Removed 4 layers of stone
- Reduced startup time
- Reduced player speed
- Press N to nuke

## Alpha 0.1.2
*24/02/2019 09:19*
- Added coordinates to UI
- Modified player position.
- Changed menu buttons from "Start" to "PLAY" and "Exit" to "EXIT"
- Changed logo

## Alpha 0.1.1
*24/02/2019 08:09*
- Reddened redwood log
- Modified redwood leaf
- Modified sky slightly
- Trees no longer grow into the ground
- Grass no longer overrides blocks on top of it

## Alpha 0.1.0
*23/02/2019 19:56*
- Added menu
- Added physics and gravity
- Tree logs now grow into the ground
- Version number is now on the menu
- Added sky

## Indev 0.0.7
*23/02/2019 09:28*
- Chunks no longer have the same grass Y-level internally
- Tree chance per chunk changed to 1/16 from 1/17
- Changed block IDs: stone 1-4, grass 16-12, oak_log 24-16, 
-  birch_log 25-17, spruce_log 26-18, oak_leaf 32-20, 
-  birch_leaf 33-21, spruce_leaf 34-22
- Added log top textures
- Removed debug1
- Changed texture of debug and all log textures
- Renamed birch to redwood
- Remove sticky-out leaves
- Added clay (ID 5)
- Grass generated below y=12 is clay

## Indev 0.0.6
*19/02/2019 20:02*
- Tilting camera no longer moves player
- Birch trees now grow to 7-11 blocks tall
- Added chunks, chunk size is set to math.random(3,6)
- Swapped X and Y axes of blocks tilesheet
- Changed block IDS: stone 1to0, dirt 2to8, grass 3to16,
-  logOak 5to24, leafOak 6to32, logBirch 7to25, leafBirch 8to33
- Removed unused air block
- Changed down from LCtrl to LShift
- Added spruce log and leaf
- Added spruce trees which are 6-8 blocks tall
- Retextured birch leaf and log
- Removed biomes
- Changed block IDs from camelCase to underscore_case
- Added bedrock which generates along y=0
- Removed unused grass textures

## Indev 0.0.5
*17/02/2019 20:39*
- Added oak and birch log and leaf blocks
- Added trees
- Added proto-biomes
- Added unused forest grass textures
- Modified world gen to have layers

## Indev 0.0.4
*17/02/2019 17:37*
- Fixed vertical movement
- Added random world generation
- Reversed block IDs (stone=1, dirt=2, grass=3)
- Version text is now in the centre of the screen

## Indev 0.0.3
*17/02/2019 08:51*
- Added air, grass, dirt and stone blocks (IDs 0, 1, 2 & 3)
- Added new map
- Doubled movement speed
- Fixed movement and uninverted looking
- Set FOV to 70
- Made version text smaller

## Indev 0.0.2
*16/02/2019 10:12*
- Added movement
- Added font file
- Added version number to top-left corner
- Fixed gap in terrain
- Made character taller
- Hid character

## Indev 0.0.1
*14/02/2019 20:18*
- Added player model
- Added environment
- Added camera