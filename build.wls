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

root   = DirectoryName[$InputFileName];
buildDir = FileNameJoin[{root, "build"}];

If[!DirectoryQ[buildDir], CreateDirectory[buildDir]];

(* Validate the paclet metadata. *)
info = Get[FileNameJoin[{root, "PacletInfo.wl"}]];
If[Head[info] =!= PacletObject,
    Print["PacletInfo.wl did not return a PacletObject"]; Exit[1]
];

name    = info["Name"];
version = info["Version"];
Print["Packing ", name, " v", version, " ..."];

(* Clean previous artefacts for the same version. *)
Scan[DeleteFile,
    FileNames["*.paclet", buildDir]
];

pacletFile = PackPaclet[root, buildDir];

If[FileExistsQ[pacletFile],
    Print["Built: ", pacletFile]
    ,
    Print["PackPaclet failed."]; Exit[1]
];
