(* ::Package:: *)

(* ::Title:: *)
(*WolframModelEvolutionObject*)


(* ::Text:: *)
(*This is an object that is returned by WolframModel. It allows one to query the set at different generations and different steps.*)


Package["SetReplace`"]


PackageExport["WolframModelEvolutionObject"]


PackageScope["propertyEvaluate"]


PackageScope["$propertiesParameterless"]
PackageScope["$newParameterlessProperties"]


(* ::Text:: *)
(*Keys in the data association.*)


PackageScope["$creatorEvents"]
PackageScope["$destroyerEvents"]
PackageScope["$generations"]
PackageScope["$atomLists"]
PackageScope["$rules"]
PackageScope["$maxCompleteGeneration"]
PackageScope["$terminationReason"]
PackageScope["$eventRuleIDs"]


$creatorEvents = "CreatorEvents";
$destroyerEvents = "DestroyerEvents";
$generations = "Generations";
$atomLists = "AtomLists";
$rules = "Rules";
$maxCompleteGeneration = "MaxCompleteGeneration";
$terminationReason = "TerminationReason";
$eventRuleIDs = "EventRuleIDs";


(* ::Section:: *)
(*Documentation*)


WolframModelEvolutionObject::usage = usageString[
	"WolframModelEvolutionObject[`...`] is an evolution object generated by ",
	"WolframModel.",
	"\n",
	"WolframModelEvolutionObject[`...`][`g`] yields the set at generation `g`.",
	"\n",
	"WolframModelEvolutionObject[`...`][\"StateAfterEvent\", `s`] yields the state ",
	"after `s` substitution events.",
	"\n",
	"WolframModelEvolutionObject[`...`][\"Properties\"] yields the list of all ",
	"available properties."];


(* ::Section:: *)
(*SyntaxInformation*)


SyntaxInformation[WolframModelEvolutionObject] = {"ArgumentsPattern" -> {___}};


(* ::Section:: *)
(*Boxes*)


WolframModelEvolutionObject /:
		MakeBoxes[
			evo : WolframModelEvolutionObject[data_ ? evolutionDataQ],
			format_] := Module[
	{generationsCount, maxCompleteGeneration, eventsCount, terminationReason, rules, initialSet},
	generationsCount = evo["TotalGenerationsCount"];
	maxCompleteGeneration = Replace[evo["CompleteGenerationsCount"], _ ? MissingQ -> "?"];
	generationsDisplay = If[generationsCount === maxCompleteGeneration,
		generationsCount,
		Row[{maxCompleteGeneration, "\[Ellipsis]", generationsCount}]];
	eventsCount = evo["AllEventsCount"];
	terminationReason = evo["TerminationReason"];
	rules = data[$rules];
	initialSet = evo[0];
	BoxForm`ArrangeSummaryBox[
		WolframModelEvolutionObject,
		evo,
		style[$lightTheme][$evolutionObjectIcon],
		(* Always grid *)
		{{BoxForm`SummaryItem[{"Generations: ", generationsDisplay}]},
		{BoxForm`SummaryItem[{"Events: ", eventsCount}]}},
		(* Sometimes grid *)
		{If[MissingQ[terminationReason], Nothing, {BoxForm`SummaryItem[{"Termination reason: ", terminationReason}]}],
		{BoxForm`SummaryItem[{"Rules: ", Short[rules]}]},
		{BoxForm`SummaryItem[{"Initial set: ", Short[initialSet]}]}},
		format,
		"Interpretable" -> Automatic
	]
]


(* ::Section:: *)
(*Implementation*)


$accessorProperties = <|
	"EdgeCreatorEventIndices" -> $creatorEvents,
	"EdgeDestroyerEventIndices" -> $destroyerEvents,
	"EdgeGenerationsList" -> $generations,
	"AllEventsEdgesList" -> $atomLists,
	"CompleteGenerationsCount" -> $maxCompleteGeneration
|>;


$propertyArgumentCounts = Join[
	<|
		"EvolutionObject" -> {0, 0},
		"FinalState" -> {0, 0},
		"FinalStatePlot" -> {0, Infinity},
		"StatesList" -> {0, 0},
		"StatesPlotsList" -> {0, Infinity},
		"EventsStatesPlotsList" -> {0, Infinity},
		"AllEventsStatesEdgeIndicesList" -> {0, 0},
		"AllEventsStatesList" -> {0, 0},
		"Generation" -> {1, 1},
		"StateEdgeIndicesAfterEvent" -> {1, 1},
		"StateAfterEvent" -> {1, 1},
		"Rules" -> {0, 0},
		"TotalGenerationsCount" -> {0, 0},
		"PartialGenerationsCount" -> {0, 0},
		"GenerationsCount" -> {0, 0},
		"GenerationComplete" -> {0, 1},
		"AllEventsCount" -> {0, 0},
		"GenerationEventsCountList" -> {0, 0},
		"GenerationEventsList" -> {0, 0},
		"FinalDistinctElementsCount" -> {0, 0},
		"AllEventsDistinctElementsCount" -> {0, 0},
		"VertexCountList" -> {0, 0},
		"EdgeCountList" -> {0, 0},
		"FinalEdgeCount" -> {0, 0},
		"AllEventsEdgesCount" -> {0, 0},
		"AllEventsGenerationsList" -> {0, 0},
		"CausalGraph" -> {0, Infinity},
		"LayeredCausalGraph" -> {0, Infinity},
		"TerminationReason" -> {0, 0},
		"AllEventsRuleIndices" -> {0, 0},
		"AllEventsList" -> {0, 0},
		"EventsStatesList" -> {0, 0},
		"Properties" -> {0, 0}|>,
	Association[# -> {0, 0} & /@ Keys[$accessorProperties]]];


(*This are here for compatibility with old code.*)
$oldToNewPropertyNames = <|
	"UpdatedStatesList" -> "AllEventsStatesList",
	"AllExpressions" -> "AllEventsEdgesList",
	"CreatorEvents" -> "EdgeCreatorEventIndices",
	"DestroyerEvents" -> "EdgeDestroyerEventIndices",
	"MaxCompleteGeneration" -> "CompleteGenerationsCount",
	"EventGenerations" -> "AllEventsGenerationsList",
	"EventGenerationsList" -> "AllEventsGenerationsList",
	"ExpressionGenerations" -> "EdgeGenerationsList",
	"EventsCount" -> "AllEventsCount",
	"EventsList" -> "AllEventsList",
	"AtomsCountFinal" -> "FinalDistinctElementsCount",
	"AtomsCountTotal" -> "AllEventsDistinctElementsCount",
	"ExpressionsCountFinal" -> "FinalEdgeCount",
	"ExpressionsCountTotal" -> "AllEventsEdgesCount",
	"SetAfterEvent" -> "StateAfterEvent"
|>;


$propertiesParameterless = Join[
  Keys @ Select[#[[1]] == 0 &] @ $propertyArgumentCounts,
  Select[First[$propertyArgumentCounts[$oldToNewPropertyNames[#]]] == 0 &] @ Keys[$oldToNewPropertyNames]
];


$newParameterlessProperties = Intersection[$propertiesParameterless, Keys[$propertyArgumentCounts]];


(* ::Subsection:: *)
(*Argument checks*)


(* ::Subsection:: *)
(*Master options handling*)


General::missingMaxCompleteGeneration = "Cannot drop incomplete generations in an object with missing information.";


propertyEvaluate[False, boundary_][evolution_, caller_, rest___] := If[MissingQ[evolution["CompleteGenerationsCount"]],
	Message[caller::missingMaxCompleteGeneration],
	propertyEvaluate[True, boundary][deleteIncompleteGenerations[evolution], caller, rest]
]


propertyEvaluate[includePartialGenerations : Except[True | False], _][evolution_, caller_, ___] :=
	Message[caller::invalidFiniteOption, "IncludePartialGenerations", includePartialGenerations, {True, False}]


includeBoundaryEventsPattern = None | "Initial" | "Final" | All;


propertyEvaluate[_, boundary : Except[includeBoundaryEventsPattern]][evolution_, caller_, ___] :=
	Message[caller::invalidFiniteOption, "IncludeBoundaryEvents", boundary, {None, "Initial", "Final", All}]


deleteIncompleteGenerations[WolframModelEvolutionObject[data_]] := Module[{
		maxCompleteGeneration, expressionsToDelete, lastGenerationExpressions, expressionsToKeep, eventsToDelete,
		eventsCount, eventsToKeep, eventRenameRules},
	maxCompleteGeneration = data[$maxCompleteGeneration];
	{expressionsToDelete, lastGenerationExpressions} =
		Position[data[$generations], _ ? #][[All, 1]] & /@ {# > maxCompleteGeneration &, # == maxCompleteGeneration &};
	expressionsToKeep = Complement[Range[Length[data[$generations]]], expressionsToDelete];
	eventsToDelete =
		Union[data[$creatorEvents][[expressionsToDelete]], data[$destroyerEvents][[lastGenerationExpressions]]];
	eventsCount = WolframModelEvolutionObject[data]["AllEventsCount"];
	eventsToKeep = Complement[Range[eventsCount], eventsToDelete];
	eventRenameRules =
		Dispatch[Join[Thread[eventsToKeep -> Range[Length[eventsToKeep]]], Thread[eventsToDelete -> Infinity]]];
	WolframModelEvolutionObject[<|
		$creatorEvents -> data[$creatorEvents][[expressionsToKeep]] /. eventRenameRules,
		$destroyerEvents -> data[$destroyerEvents][[expressionsToKeep]] /. eventRenameRules,
		$generations -> data[$generations][[expressionsToKeep]],
		$atomLists -> data[$atomLists][[expressionsToKeep]],
		$rules -> data[$rules],
		$maxCompleteGeneration -> data[$maxCompleteGeneration],
		$terminationReason -> data[$terminationReason],
		$eventRuleIDs -> data[$eventRuleIDs][[eventsToKeep]]
	|>]
]


(* ::Subsubsection:: *)
(*Unknown property*)


propertyEvaluate[masterOptions___][
		obj_WolframModelEvolutionObject, caller_, property : Alternatives @@ Keys[$oldToNewPropertyNames], args___] :=
	propertyEvaluate[masterOptions][obj, caller, $oldToNewPropertyNames[property], args]


propertyEvaluate[___][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		s : Except[_Integer],
		___] := 0 /;
	!MemberQ[Keys[$propertyArgumentCounts], s] &&
	makeMessage[caller, "unknownProperty", s]


(* ::Subsubsection:: *)
(*Property argument counts*)


makePargxMessage[property_, caller_, givenArgs_, expectedArgs_] := makeMessage[
	caller,
	"pargx",
	property,
	givenArgs,
	If[givenArgs == 1, "", "s"],
	If[expectedArgs[[1]] != expectedArgs[[2]], "between ", ""],
	expectedArgs[[1]],
	If[expectedArgs[[1]] != expectedArgs[[2]], " and ", ""],
	If[expectedArgs[[1]] != expectedArgs[[2]], expectedArgs[[2]], ""],
	If[expectedArgs[[1]] != expectedArgs[[2]] || expectedArgs[[1]] != 1, "s", ""],
	If[expectedArgs[[1]] != expectedArgs[[2]] || expectedArgs[[1]] != 1, "are", "is"]
]


propertyEvaluate[___][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		s_String,
		args___] := 0 /;
	With[{argumentsCountRange = $propertyArgumentCounts[s]},
		Not[MissingQ[argumentsCountRange]] &&
		Not[argumentsCountRange[[1]] <= Length[{args}] <= argumentsCountRange[[2]]] &&
		makePargxMessage[s, caller, Length[{args}], argumentsCountRange]]


(* ::Subsubsection:: *)
(*Correct options*)


$propertyOptions = <|
	"CausalGraph" -> Options[Graph],
	"LayeredCausalGraph" -> Options[Graph],
	"StatesPlotsList" -> Options[WolframModelPlot],
	"EventsStatesPlotsList" -> Options[WolframModelPlot],
	"FinalStatePlot" -> Options[WolframModelPlot]
|>;


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		property : Alternatives @@ Keys[$propertyOptions],
		o : OptionsPattern[]] := Message[
			caller::optx,
			First[Last[Complement[{o}, FilterRules[{o}, Options[$propertyOptions[property]]]]]],
			Defer[obj[property, o]]]


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		property : Alternatives @@ Keys[$propertyOptions],
		o___] := makeMessage[caller, "nonopt", property, Last[{o}]]


(* ::Subsection:: *)
(*Properties*)


propertyEvaluate[___][
		WolframModelEvolutionObject[data_ ? evolutionDataQ], caller_, "Properties"] :=
	Keys[$propertyArgumentCounts]


(* ::Subsection:: *)
(*EvolutionObject*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"EvolutionObject"] := WolframModelEvolutionObject[data]


(* ::Subsection:: *)
(*Rules*)


propertyEvaluate[___][
		WolframModelEvolutionObject[data_ ? evolutionDataQ], caller_, "Rules"] :=
	data[$rules]


(* ::Subsection:: *)
(*TotalGenerationsCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"TotalGenerationsCount"] := Max[
	0,
	Max @ data[$generations],
	1 + Max @ data[$generations][[
		Position[
			data[$destroyerEvents], Except[{}], {1}, Heads -> False][[All, 1]]]]]


(* ::Subsection:: *)
(*PartialGenerationsCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		"PartialGenerationsCount"] :=
	If[MissingQ[obj["CompleteGenerationsCount"]],
		obj["CompleteGenerationsCount"],
		obj["TotalGenerationsCount"] - obj["CompleteGenerationsCount"]]


(* ::Subsection:: *)
(*GenerationsCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		"GenerationsCount"] := obj /@ {"CompleteGenerationsCount", "PartialGenerationsCount"}


(* ::Subsection:: *)
(*GenerationComplete*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		"GenerationComplete",
		generation_Integer] /; generation >= 0 := generation <= obj["CompleteGenerationsCount"]


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		"GenerationComplete",
		generation_ : -1] :=
	toPositiveStep[
			propertyEvaluate[True, None][obj, caller, "TotalGenerationsCount"], generation, caller, "Generation"] <=
		obj["CompleteGenerationsCount"]


(* ::Subsection:: *)
(*AllEventsCount*)


propertyEvaluate[True, includeBoundaryEvents : includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ], caller_, "AllEventsCount"] :=
	Max[0, DeleteCases[Join[data[$destroyerEvents], data[$creatorEvents]], Infinity]] +
		Switch[includeBoundaryEvents, None, 0, "Initial" | "Final", 1, All, 2]


(* ::Subsection:: *)
(*GenerationEventsCountList*)


propertyEvaluate[True, includeBoundaryEvents : includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ], caller_, "GenerationEventsCountList"] :=
	Length /@ Split[propertyEvaluate[True, includeBoundaryEvents][obj, caller, "AllEventsGenerationsList"]]


(* ::Subsection:: *)
(*GenerationEventsList*)


propertyEvaluate[True, includeBoundaryEvents : includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ], caller_, "GenerationEventsList"] :=
	TakeList[
		propertyEvaluate[True, includeBoundaryEvents][obj, caller, "AllEventsList"],
		propertyEvaluate[True, includeBoundaryEvents][obj, caller, "GenerationEventsCountList"]]


(* ::Subsection:: *)
(*Direct Accessors*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		property_ ? (MemberQ[Keys[$accessorProperties], #] &)] :=
	Lookup[data, $accessorProperties[property], Missing["NotAvailable"]];


(* ::Subsecion:: *)
(*StateEdgeIndicesAfterEvent*)


(* ::Subsubsection:: *)
(*Convert to positive generation number*)


toPositiveStep[total_, requested_Integer, caller_, name_] /; 0 <= requested <= total := requested


toPositiveStep[total_, requested_Integer, caller_, name_] /; - total - 1 <= requested < 0 := 1 + total + requested


toPositiveStep[total_, requested_Integer, caller_, name_] /; !(- total - 1 <= requested <= total) :=
  makeMessage[caller, "stepTooLarge", name, requested, total]


toPositiveStep[total_, requested : Except[_Integer], caller_, name_] :=
  makeMessage[caller, "stepNotInteger", name, requested]


(* ::Subsubsection:: *)
(*Implementation*)


propertyEvaluate[True, includeBoundaryEventsPattern][
			obj : WolframModelEvolutionObject[data_ ? evolutionDataQ],
			caller_,
			"StateEdgeIndicesAfterEvent",
			s_] := With[{
		positiveEvent = toPositiveStep[propertyEvaluate[True, None][obj, caller, "AllEventsCount"], s, caller, "Event"]},
	Intersection[
		Position[data[$creatorEvents], _ ? (# <= positiveEvent &)][[All, 1]],
		Position[Min /@ data[$destroyerEvents], _ ? (# > positiveEvent &)][[All, 1]]]
]


(* ::Subsection:: *)
(*StateAfterEvent*)


propertyEvaluate[True, boundary : includeBoundaryEventsPattern][
			obj : WolframModelEvolutionObject[data_ ? evolutionDataQ],
			caller_,
			"StateAfterEvent",
			s_] := data[$atomLists][[propertyEvaluate[True, boundary][obj, caller, "StateEdgeIndicesAfterEvent", s]]]


(* ::Subsection:: *)
(*FinalState*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"FinalState"] := WolframModelEvolutionObject[data]["StateAfterEvent", -1]


(* ::Subsection:: *)
(*FinalStatePlot*)


General::nonHypergraphPlot = "`1` is only supported for states that are hypergraphs.";


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		property : "FinalStatePlot",
		o : OptionsPattern[] /; (Complement[{o}, FilterRules[{o}, Options[WolframModelPlot]]] == {})] :=
	Quiet[
		Check[
			WolframModelPlot[obj["FinalState"], o],
			Message[caller::nonHypergraphPlot, property],
			WolframModelPlot::invalidEdges],
		WolframModelPlot::invalidEdges]


(* ::Subsection:: *)
(*AllEventsStatesEdgeIndicesList & AllEventsStatesList*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		property : "AllEventsStatesList" | "AllEventsStatesEdgeIndicesList"] :=
	WolframModelEvolutionObject[data][
			Replace[
				property,
				{"AllEventsStatesList" -> "StateAfterEvent", "AllEventsStatesEdgeIndicesList" -> "StateEdgeIndicesAfterEvent"}],
			#] & /@
		Range[0, WolframModelEvolutionObject[data]["AllEventsCount"]]


(* ::Subsection:: *)
(*Generation*)


(* ::Text:: *)
(*Note that depending on how evaluation was done (i.e., the order of substitutions), it is possible that some expressions of a requested generation were not yet produced, and thus expressions for the previous generation would be used instead. That, however, should never happen if the evolution object is produced with WolframModel.*)


(* ::Subsubsection:: *)
(*Positive generations*)


propertyEvaluate[True, includeBoundaryEventsPattern][
			obj : WolframModelEvolutionObject[data_ ? evolutionDataQ],
			caller_,
			"Generation",
			g_] := Module[{positiveGeneration, futureEventsToInfinity},
	positiveGeneration = toPositiveStep[
		propertyEvaluate[True, None][obj, caller, "TotalGenerationsCount"], g, caller, "Generation"];
	futureEventsToInfinity = Dispatch @ Thread[Union[
			data[$creatorEvents][[
				Position[data[$generations], _ ? (# > positiveGeneration &)][[All, 1]]]],
			data[$destroyerEvents][[
				Position[data[$generations], _ ? (# >= positiveGeneration &)][[All, 1]]]]] ->
		Infinity];
	data[$atomLists][[Intersection[
		Position[
			data[$creatorEvents] /. futureEventsToInfinity,
			Except[Infinity],
			1,
			Heads -> False][[All, 1]],
		Position[
			data[$destroyerEvents] /. futureEventsToInfinity, Infinity][[All, 1]]]]]
]


(* ::Subsubsection:: *)
(*Omit "Generation"*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ], caller_, g_Integer] :=
	propertyEvaluate[True, None][WolframModelEvolutionObject[data], caller, "Generation", g]


(* ::Subsection:: *)
(*StatesList*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"StatesList"] :=
	WolframModelEvolutionObject[data]["Generation", #] & /@
		Range[0, WolframModelEvolutionObject[data]["TotalGenerationsCount"]]


(* ::Subsection:: *)
(*StatesPlotsList*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		property : "StatesPlotsList",
		o : OptionsPattern[] /; (Complement[{o}, FilterRules[{o}, Options[WolframModelPlot]]] == {})] :=
	Catch @ Quiet[
		Map[
			Check[
				Check[
					WolframModelPlot[#, o],
					Message[caller::nonHypergraphPlot, property],
					WolframModelPlot::invalidEdges],
				Throw[$Failed]] &,
			obj["StatesList"]],
		WolframModelPlot::invalidEdges]


(* ::Subsection:: *)
(*EventsStatesPlotsList*)


propertyEvaluate[True, boundary : includeBoundaryEventsPattern][
			obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
			caller_,
			property : "EventsStatesPlotsList",
			o : OptionsPattern[] /; (Complement[{o}, FilterRules[{o}, Options[WolframModelPlot]]] == {})] := Module[{
		events, stateIndices, pictures, destroyedOnlyIndices, createdOnlyIndices, destroyedAndCreatedIndices, allEdges},
	events = propertyEvaluate[True, boundary][obj, caller, "AllEventsList"][[All, 2]];
	stateIndices = FoldList[
		Join[DeleteCases[#, Alternatives @@ #2[[1]]], #2[[2]]] &,
		If[MatchQ[boundary, "Initial" | All],
			{},
			Range[Length[propertyEvaluate[True, None][obj, caller, "Generation", 0]]]
		],
		events];
	{destroyedOnlyIndices, createdOnlyIndices, destroyedAndCreatedIndices} = Transpose[MapThread[
		{Complement[##], Complement[#2, #1], Intersection[##]} &,
		{Append[events[[All, 1]], {}], Prepend[events[[All, 2]], {}]}]];
	allEdges = propertyEvaluate[True, None][obj, caller, "AllEventsEdgesList"];
	Catch @ Quiet[
		MapThread[
			Check[
				Check[
					WolframModelPlot[
						allEdges[[#]],
						o,
						EdgeStyle -> ReplacePart[
							Table[Automatic, Length[#]],
							Join[
								Thread[Position[#, Alternatives @@ #2][[All, 1]] -> style[$lightTheme][$destroyedEdgeStyle]],
								Thread[Position[#, Alternatives @@ #3][[All, 1]] -> style[$lightTheme][$createdEdgeStyle]],
								Thread[Position[#, Alternatives @@ #4][[All, 1]] ->
									style[$lightTheme][$destroyedAndCreatedEdgeStyle]]]]],
					Message[caller::nonHypergraphPlot, property],
					WolframModelPlot::invalidEdges],
				Throw[$Failed]] &,
			If[MatchQ[boundary, "Initial" | All], Rest /@ # &, # &] @
				If[MatchQ[boundary, All | "Final"], Most /@ # &, # &] @
				{stateIndices, destroyedOnlyIndices, createdOnlyIndices, destroyedAndCreatedIndices}],
		WolframModelPlot::invalidEdges]
]


(* ::Subsection:: *)
(*FinalDistinctElementsCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"FinalDistinctElementsCount"] :=
	Length[Union @ Cases[
		propertyEvaluate[True, None][
			WolframModelEvolutionObject[data], caller, "StateAfterEvent", -1],
		_ ? AtomQ,
		All]]


(* ::Subsection:: *)
(*AllEventsDistinctElementsCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"AllEventsDistinctElementsCount"] :=
	Length[Union @ Cases[data[$atomLists], _ ? AtomQ, All]]


(* ::Subsection:: *)
(*VertexCountList*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		"VertexCountList"] :=
	Length /@ Union /@ Catenate /@ obj["StatesList"]


(* ::Subsection:: *)
(*EdgeCountList*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
		caller_,
		"EdgeCountList"] :=
	Length /@ obj["StatesList"]


(* ::Subsection:: *)
(*FinalEdgeCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"FinalEdgeCount"] :=
	Length[propertyEvaluate[True, None][
		WolframModelEvolutionObject[data], caller, "StateAfterEvent", -1]]


(* ::Subsection:: *)
(*AllEventsEdgesCount*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"AllEventsEdgesCount"] :=
	Length[data[$atomLists]]


(* ::Subsection:: *)
(*AllEventsGenerationsList*)


propertyEvaluate[True, includeBoundaryEvents : includeBoundaryEventsPattern][
		evolution : WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"AllEventsGenerationsList"] :=
	If[MatchQ[includeBoundaryEvents, All | "Final"], Append[evolution["TotalGenerationsCount"] + 1], Identity] @
		If[MatchQ[includeBoundaryEvents, All | "Initial"], Prepend[0], Identity] @
		Values @
		KeySort @
		KeyDrop[
			Merge[Max] @ Join[
				Association /@ Thread[data[$creatorEvents] -> data[$generations]],
				Association /@ Catenate[Thread /@ Thread[data[$destroyerEvents] -> data[$generations] + 1]]],
			{0, Infinity}]


(* ::Subsection:: *)
(*CausalGraph / LayeredCausalGraph*)


(* ::Text:: *)
(*This produces a causal network for the system. This is a Graph with all events as vertices, and directed edges connecting them if the same event is a creator and a destroyer for the same expression (i.e., if two events are causally related).*)


(* ::Subsubsection:: *)
(*CausalGraph Implementation*)


eventsToDelete[includeBoundaryEvents : includeBoundaryEventsPattern] :=
	If[MatchQ[includeBoundaryEvents, All | #1], Nothing, #2] & @@@ {{"Initial", 0}, {"Final", Infinity}};


propertyEvaluate[True, includeBoundaryEvents : includeBoundaryEventsPattern][
		WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		property : "CausalGraph",
		o : OptionsPattern[]] /;
			(Complement[{o}, FilterRules[{o}, $propertyOptions[property]]] == {}) := With[{
		$eventsToDelete = Alternatives @@ eventsToDelete[includeBoundaryEvents]},
	Graph[
		DeleteCases[Union[data[$creatorEvents], Catenate[data[$destroyerEvents]]], $eventsToDelete],
		Select[FreeQ[#, $eventsToDelete] &] @
			Catenate[Thread /@ Thread[data[$creatorEvents] \[DirectedEdge] data[$destroyerEvents]]],
		o,
		VertexStyle -> Select[Head[#] =!= Rule || !MatchQ[#[[1]], $eventsToDelete] &] @ {
			style[$lightTheme][$causalGraphVertexStyle],
			0 -> style[$lightTheme][$causalGraphInitialVertexStyle],
			Infinity -> style[$lightTheme][$causalGraphFinalVertexStyle]},
		EdgeStyle -> style[$lightTheme][$causalGraphEdgeStyle]]
]


(* ::Subsubsection:: *)
(*LayeredCausalGraph Implementation*)


propertyEvaluate[True, includeBoundaryEvents : includeBoundaryEventsPattern][
		evolution : WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		property : "LayeredCausalGraph",
		o : OptionsPattern[]] /;
			(Complement[{o}, FilterRules[{o}, $propertyOptions[property]]] == {}) :=
	Graph[
		propertyEvaluate[True, includeBoundaryEvents][evolution, caller, "CausalGraph", ##] & @@
			FilterRules[{o}, $causalGraphOptions],
		FilterRules[{o}, Options[Graph]],
		GraphLayout -> {
			"LayeredDigraphEmbedding",
			"VertexLayerPosition" ->
				(propertyEvaluate[True, includeBoundaryEvents][evolution, caller, "TotalGenerationsCount"] -
						propertyEvaluate[True, includeBoundaryEvents][evolution, caller, "AllEventsGenerationsList"])}
	]


(* ::Subsubsection:: *)
(*TerminationReason Implementation*)


propertyEvaluate[True, includeBoundaryEventsPattern][
		evolution : WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"TerminationReason"] := Replace[data[[Key[$terminationReason]]], Join[Normal[$stepSpecKeys], {
	$fixedPoint -> "FixedPoint",
	$timeConstraint -> "TimeConstraint",
	$Aborted -> "Aborted",
	x_ ? MissingQ :> x,
	_ -> Missing["NotAvailable"]
}]]


(* ::Subsubsection:: *)
(*AllEventsRuleIndices*)


insertBoundaryEvents[boundary_, events_] :=
	If[MatchQ[boundary, "Initial" | All], Prepend[#, 0] &, Identity] @
		If[MatchQ[boundary, "Final" | All], Append[#, Infinity] &, Identity] @
		events


propertyEvaluate[True, boundary : includeBoundaryEventsPattern][
		evolution : WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"AllEventsRuleIndices"] := insertBoundaryEvents[boundary, Lookup[data, $eventRuleIDs, Missing["NotAvailable"]]]


(* ::Subsubsection:: *)
(*AllEventsList implementation*)


propertyEvaluate[True, boundary : includeBoundaryEventsPattern][
		evolution : WolframModelEvolutionObject[data_ ? evolutionDataQ],
		caller_,
		"AllEventsList"] := With[{
	ruleIndices = propertyEvaluate[True, boundary][evolution, caller, "AllEventsRuleIndices"],
	createdExpressions = PositionIndex[evolution["EdgeCreatorEventIndices"]],
	destroyedExpressions = Merge[
			Association /@
				Catenate[Thread /@ Thread[evolution["EdgeDestroyerEventIndices"] -> Range[evolution["AllEventsEdgesCount"]]]],
			# &]},
		If[MissingQ[ruleIndices],
			ruleIndices,
			MapThread[
				{#, Lookup[destroyedExpressions, #2, {}] -> Lookup[createdExpressions, #2, {}]} &,
				{ruleIndices,
					insertBoundaryEvents[boundary, Range[propertyEvaluate[True, None][evolution, caller, "AllEventsCount"]]]}]
		]
]


(* ::Subsubsection:: *)
(*EventsStatesList*)


propertyEvaluate[True, boundary : includeBoundaryEventsPattern][
			obj : WolframModelEvolutionObject[_ ? evolutionDataQ],
			caller_,
			"EventsStatesList"] := With[{
		events = propertyEvaluate[True, boundary][obj, caller, "AllEventsList"],
		states = If[MatchQ[boundary, None | "Final"], Rest, # &] @
			If[MatchQ[boundary, All | "Final"], Append[{}], # &] @
			propertyEvaluate[True, boundary][obj, caller, "AllEventsStatesEdgeIndicesList"]},
	Transpose[{events, states}]
]


(* ::Subsection:: *)
(*Public properties call*)


$masterOptions = {
	"IncludePartialGenerations" -> True,
	"IncludeBoundaryEvents" -> None
};


WolframModelEvolutionObject[
		data_ ? evolutionDataQ][
		property__ ? (Not[MatchQ[#, OptionsPattern[]]] &),
		opts : OptionsPattern[]] := Module[{prunedObject, result},
	result = Check[
		(propertyEvaluate @@
				(OptionValue[Join[{opts}, $masterOptions], #] & /@ {"IncludePartialGenerations", "IncludeBoundaryEvents"}))[
			WolframModelEvolutionObject[data],
			WolframModelEvolutionObject,
			property,
			##] & @@ Flatten[FilterRules[{opts}, Except[$masterOptions]]],
		$Failed];
	result /; result =!= $Failed
]


(* ::Section:: *)
(*Argument Checks*)


(* ::Text:: *)
(*Argument Checks should be evaluated after Implementation, otherwise ::corrupt messages will be created while assigning SubValues.*)


(* ::Subsection:: *)
(*Argument count*)


WolframModelEvolutionObject[args___] := 0 /;
	!Developer`CheckArgumentCount[WolframModelEvolutionObject[args], 1, 1] && False


WolframModelEvolutionObject[data_][opts : OptionsPattern[]] := 0 /;
  Message[WolframModelEvolutionObject::argm, Defer[WolframModelEvolutionObject[data][opts]], 0, 1]


(* ::Subsection:: *)
(*Association has correct fields*)


WolframModelEvolutionObject::corrupt =
	"WolframModelEvolutionObject does not have a correct format. " <>
	"Use WolframModel for construction.";


evolutionDataQ[data_Association] :=
	SubsetQ[
		Keys[data],
		{$creatorEvents, $destroyerEvents, $generations, $atomLists, $rules}] &&
	SubsetQ[
		{$creatorEvents, $destroyerEvents, $generations, $atomLists, $rules, $maxCompleteGeneration, $terminationReason,
			$eventRuleIDs},
		Keys[data]
	]


evolutionDataQ[___] := False


WolframModelEvolutionObject[data_] := 0 /;
	!evolutionDataQ[data] &&
	Message[WolframModelEvolutionObject::corrupt]
