# Dialogue
A dialogue creation tool addon for [Godot](www.godotengine.org). 

## Features

### Basic
- [ ] **Node indexing:** each branch on a dialogue tree has a unique index.
- [ ] **Add/Remove Chioces:** ability to add and remove chioces, up to a limit.
- [ ] **Sequence:** branch choices automatically lead the connected node.
- [ ] **Conversation:** NPC rich text box to input text.
- [ ] **Embedding:** write conversation and choice text within the node without needing to open seperate windows.
- [ ] **End:** every tree must have a dialogue end node.
- [ ] **Export:** ability to export to JSON.
- [ ] **Sidebar:** See each dialogue in containers on the side (like an explorer sidebar).

### Advanced
- [ ] **Hide:** being able to determine if chioces are visible to the player.
- [ ] **Conditions:** Skill, Character, item checks for dialogue options making them un/avaiable (multiple in a single check).
- [ ] **Anchoring:** Skill, Character, Item are enums/pre-defined to prevent bugs.
- [ ] **Loop:** go back to prevoius branches.
- [ ] **Variables:** making changes to the state of the player or world.


### Debugging
- [ ] **Itteration:** being able to play the dialogue sequence before exporting
- [ ] **Step History:** see node sequence based on unique index
- [ ] **Variables:** making changes to the state of the player.
- [ ] **Logging:** ability to revist a log file with history of dialogues and chioces. Pass/Fail checks and respective variable.
- [ ] **Profiling:** Different character presets for testing narrative.
- [ ] **Balance:** Ability to see how many condition checks there are in the game and of which type 
- [ ] **Search:** Ability to find node based on nodeID
- [ ] **Null:** Ability to check if conditions point to null target