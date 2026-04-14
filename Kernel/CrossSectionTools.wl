(* ::Package:: *)

(* :Title: CrossSectionTools *)
(* :Context: CrossSectionTools` *)
(* :Author: Jan Tomec *)
(* :Summary: Compute cross section properties for an arbitrary 2D shape. *)
(* :License: MIT *)

BeginPackage["CrossSectionTools`", {"NDSolve`FEM`"}]

CrossSection::usage =
  "CrossSection[region] computes area, mass centre, moments of inertia and \
torsion constant of a 2D region and returns a labelled summary with a plot. \
CrossSection[region, units] uses the given unit string (default \"mm\") in \
the results table.";

TorsionConstant::usage =
  "TorsionConstant[mesh] computes Saint-Venant's torsion constant \!\(\*SubscriptBox[\(J\), \(t\)]\) \
of a 2D cross section given as a MeshRegion or ElementMesh.";

Begin["`Private`"]

(* ---- TorsionConstant ---------------------------------------------------- *)

Clear[TorsionConstant];

TorsionConstant[mesh_?MeshRegionQ] :=
    TorsionConstant[ToElementMesh[mesh]];

TorsionConstant[mesh_ElementMesh] := Module[
    {\[Psi], u, y, z},
    \[Psi] = NDSolveValue[
        {
            Laplacian[u[y, z], {y, z}] == -2,
            DirichletCondition[u[y, z] == 0, True]
        },
        u, {y, z} \[Element] mesh
    ];
    2 NIntegrate[\[Psi][y, z], {y, z} \[Element] mesh]
];

(* ---- CrossSection ------------------------------------------------------- *)

Clear[CrossSection];

CrossSection[region : _?RegionQ, units_ : "mm"] := Module[
    {mesh, data, A, yt, zt, y, z, colors, w, h},

    (* Convert to mesh *)
    mesh = DiscretizeRegion[region];

    data = {{"Measure", "Value", "Units"}};

    (* Area *)
    A = Area[mesh];
    AppendTo[data, {"A", A, units^2}];

    (* Mass center *)
    {yt, zt} = NIntegrate[{y, z}, {y, z} \[Element] mesh] / A;

    (* Bounds *)
    {w, h} = (#[[2]] - #[[1]]) & /@ RegionBounds[mesh];

    (* Moment of inertia *)
    AppendTo[data, {"\!\(\*SubscriptBox[\(I\), \(\*SubscriptBox[\(y\), \(t\)] \*SubscriptBox[\(y\), \(t\)]\)]\)",
        NIntegrate[(y - yt)^2, {y, z} \[Element] mesh], units^4}];
    AppendTo[data, {"\!\(\*SubscriptBox[\(I\), \(\*SubscriptBox[\(z\), \(t\)] \*SubscriptBox[\(z\), \(t\)]\)]\)",
        NIntegrate[(z - zt)^2, {y, z} \[Element] mesh], units^4}];
    AppendTo[data, {"\!\(\*SubscriptBox[\(I\), \(\*SubscriptBox[\(y\), \(t\)] \*SubscriptBox[\(z\), \(t\)]\)]\)",
        NIntegrate[(y - yt) (z - zt), {y, z} \[Element] mesh], units^4}];
    AppendTo[data, {"\!\(\*SubscriptBox[\(I\), \(\*SubscriptBox[\(x\), \(t\)] \*SubscriptBox[\(x\), \(t\)]\)]\)",
        NIntegrate[(y - yt)^2 + (z - zt)^2, {y, z} \[Element] mesh], units^4}];
    AppendTo[data, {"\!\(\*SubscriptBox[\(J\), \(t\)]\)",
        TorsionConstant[mesh], units^4}];

    (* Visualize *)
    colors = ColorData[97, "ColorList"];
    Grid[{{
        Grid[data,
            Alignment -> Left,
            Spacings -> {2, 1},
            Frame -> All,
            ItemStyle -> "Text",
            Background -> {
                {RGBColor["#bfbfbf"], None},
                {RGBColor["#f2f2f2"], None}
            }
        ],
        Show[
            RegionPlot[mesh, AxesLabel -> {"y", "z"}],
            Graphics[{
                {Arrow[{{yt - (w + h)/10, zt}, {yt + (w + h)/10, zt}}]},
                {Arrow[{{yt, zt - (w + h)/10}, {yt, zt + (w + h)/10}}]},
                {Text[Style["\!\(\*SubscriptBox[\(y\), \(t\)]\)", FontSize -> 14],
                    {yt + (w + h)/7.7, zt}]},
                {Text[Style["\!\(\*SubscriptBox[\(z\), \(t\)]\)", FontSize -> 14],
                    {yt, zt + (w + h)/7.7}]},
                {PointSize[0.03], Point[{yt, zt}]}
            }]
        ]
    }}]
];

End[] (* `Private` *)

EndPackage[]
