RSRC                 	   Resource            Z�=J�N   GraphState                                                   resource_local_to_scene    resource_name    script    _currentID    _availableID    _nodes    _connections       Script -   res://addons/dio/graph/source/graph_state.gd ��������      local://Resource_g1d78 \      	   Resource                                                              id             name ,      node3       text       You selected Choice A.       choices "      	   Continue    	   position 
     �C  4�            id             name ,      node1       text    P   This dialogue node does not have choices, instead conversation texts are linked       choices "      	   Continue    	   position 
     ��  ��            id             name ,      node5       text    !   This is the end of the dialogue.       choices "         Exit    	   position 
     \D  p�            id             name ,      node2       text    U   This dialogue node has choices. The choices are linked to the next conversation text       choices "      	   Choice A 	   Choice B    	   position 
     ��  ��            id             name ,      node4       text       You selected Choice B.       choices "      	   Continue    	   position 
     �C  HC                  
   from_node ,      node1    
   from_port              to_node ,      node2       to_port                 
   from_node ,      node2    
   from_port              to_node ,      node3       to_port                 
   from_node ,      node2    
   from_port             to_node ,      node4       to_port                 
   from_node ,      node3    
   from_port              to_node ,      node5       to_port                 
   from_node ,      node4    
   from_port              to_node ,      node5       to_port        RSRC