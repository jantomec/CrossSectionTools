#!/usr/bin/env wolframscript
(* ::Package:: *)

(* build.wls -- package this directory into a .paclet file.

   Usage:
       wolframscript -file build.wls

   Produces CrossSectionTools-<version>.paclet in the ./build directory,
   which can be attached to a GitHub release. Install with:

       PacletInstall["path/to/CrossSectionTools-<version>.paclet"]
*)

Needs["PacletManager`"];

root     = DirectoryName[$InputFileName];
buildDir = FileNameJoin[{root, "build"}];

If[!DirectoryQ[buildDir], CreateDirectory[buildDir]];

(* Validate paclet metadata. *)
info = Get[FileNameJoin[{root, "PacletInfo.wl"}]];
If[Head[info] =!= PacletObject,
    Print["PacletInfo.wl did not return a PacletObject"]; Exit[1]
];

Print["Packing ", info["Name"], " v", info["Version"], " ..."];

(* Build the documentation search index so reference pages are discoverable
   from the Documentation Center after install. PacletTools is distributed
   as a paclet; fetch it if it is missing. *)
If[FailureQ[Quiet @ Needs["PacletTools`"]],
    Print["Installing PacletTools ..."];
    PacletInstall["PacletTools"];
    Needs["PacletTools`"]
];

Print["Building documentation ..."];
docResult = PacletDocumentationBuild[root];
If[FailureQ[docResult],
    Print["Warning: PacletDocumentationBuild returned a Failure. ",
        "The paclet will still build, but documentation may not be indexed."];
    Print[docResult]
];

(* Remove previous paclet artefacts. *)
Scan[DeleteFile, FileNames["*.paclet", buildDir]];

pacletFile = PackPaclet[root, buildDir];

If[FileExistsQ[pacletFile],
    Print["Built: ", pacletFile]
    ,
    Print["PackPaclet failed."]; Exit[1]
];
