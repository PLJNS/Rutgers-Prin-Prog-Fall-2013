%%%% coloring a graph

%%% a graph is a list of nodes
%%% a node is made with the functor node with arguments:
%%%  - name, a symbol (e.g. a or x)
%%%  - color, an integer
%%%  - neighbors, a list of node names (Note:  just the names, not the
%%%    node(...) structures) of nodes that neighbors of name,
%%% such that no two nodes in a graph have the same name and if a is a
%%% neighbor of b, b is a neighbor of a

%%% node_structure(+Name, +Graph, -Structure) Graph is assumed to be a
%%% graph and Name is assumed to be the name of one of its nodes.
%%% Structure is the node structure in Graph with name Name.

node_structure(Name, [node(Name, Color, NbrNames) | _],node(Name, Color, NbrNames)).
node_structure(Name, [_ | T], Structure):- node_structure(Name,T, Structure).

%%% all_names(+Graph, -Names) 
%%% Graph is a list of nodes structures,
%%% Names is a list of just the names from the nodes in Graph.
%%% all_names([ ], [ ]). is true, since the empty graph has no nodes.

%%% fill in all_names here

all_names([],[]).

%%% all_unique(+List) List is assumed to be a list of symbols.
%%% all_unique is true if and only if there are no duplicate symbols
%%% in List.  E.g., all_unique([a, b, c]) is true, as is
%%% all_unique([ ]), but all_unique([a, b, a]) is false.

%%% fill in all_unique here

all_unique([]).
all_unique([FIRST|SECOND]) :- (\+ member(FIRST,SECOND)), all_unique(SECOND).

%%% node_backlinks_valid(+Name, +NbrNames, +Graph) Name is assumed to be a
%%% node name (not a node_structure), NbrNames is assumed to be a list of
%%% some of its neighbor names (not node_structures), and Graph is
%%% assumed to be a graph.  True if and only if every node in NbrNames has
%%% Name as a neighbor in Graph.  E.g. if G is [node(c, 0, [ ]),
%%% node(b, 0, [a, c]), node(a, 0, [b])] node_backlinks_valid(a, [b],
%%% G) is true but node_backlinks_valid(b, [a, c]), G) is false
%%% because b is not in c's neighbor list in G.  If NbrNames is [ ],
%%% node_backlinks_valid is always true.

%%% fill in node_backlinks_valid here

node_backlinks_valid(_, _, []).

%%% all_backlinks_valid(+Node_structs, +Graph) Node_structs is assumed
%%% to be a list of node structures, Graph a graph.  It is true if and
%%% only if all the node structures in Node_structs are backlink valid in Graph.
%%% all_backlinks_valid([ ], Graph) is true

%%% fill in all_backlinks_valid here

all_backlinks_valid([], _).

%%% graph_valid(+G) G is assumed to be a graph.  It is true iff all the node
%%% names in G are unique and all the backlinks in G are valid

graph_valid(G):-
	all_names(G, Names), all_unique(Names), all_backlinks_valid(G, G).

%%% max_color(k) means k is the number of colors allowed.  Change the
%%% next line to change k from 3 to whatever.

max_color(3).  

%%% color(-N) N is an integer in the range from 1 thru max color

color(N):- max_color(M), between(1,M,N). % between is a builtin
	   		 		 % predicate that is true if
					 % 1 <= N <= M

%%% colors_of(+Names, +Graph, -Colors) Names is a list of node names,
%%% Graph is a list of node structures, Colors is the list of colors
%%% that Nodes have in Graph.  colors_of([ ], _, [ ]) is true.

%%% fill in colors_of here

colors_of(_,[],[]).

%%% valid_colors(+G) G is assumed to be a graph, True iff G is legally
%%% colored, ie if no arc links two nodes of the same color.

valid_colors(All_nodes):-valid_colors(All_nodes, All_nodes).

%%% valid_colors(+Nodes, +Graph) Nodes is a list of node structures,
%%% Graph is a graph.  Nodes is Grap or a tail (cdr of cdr ... of cdr)
%%% of Graph.  True iff each nodes in Nodes has a different color than
%%% its neighbors in Graph. I.e., tests if Graph is properly colored.

valid_colors([ ], _).
valid_colors([node(_,Color,NbrNames) | Nodes], All_nodes):-
	colors_of(NbrNames, All_nodes, Colors),
	\+(member(Color, Colors)),
	valid_colors(Nodes, All_nodes).

%%% colored_nodes(Nodes) Nodes is a list of node structures with a
%%% color filled in for each structure.  If Graph has variables for
%%% node colors, colored_nodes(Graph) will bind those variables to
%%% colors, i.e., generate a coloring.

colored_nodes([ ]).
colored_nodes([node(_, Color, _) | Nodes]):-
	color(Color),
	colored_nodes(Nodes).

%%% solve_coloring(+Nodes) Nodes is a graph, ie a coloring problem,
%%% Chooses a valid color for each node in nodes.  Hint: use generate
%%% and test, with colored_nodes for a genrator and valid_colors for a
%%% test

%%% fill in solve_coloring here
solve_coloring(N)	:-	graph_valid(N),
						colored_nodes(N),
						valid_colors(N).

