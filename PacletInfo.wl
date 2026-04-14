PacletObject[ <|
    "Name"             -> "JanTomec/CrossSectionTools",
    "Description"      -> "Compute cross section properties (area, centroid, moments of inertia, torsion constant) for an arbitrary 2D shape.",
    "Creator"          -> "Jan Tomec",
    "URL"              -> "https://github.com/jantomec/CrossSectionTools",
    "SourceControlURL" -> "https://github.com/jantomec/CrossSectionTools",
    "License"          -> "MIT",
    "PublisherID"      -> "JanTomec",
    "Version"          -> "1.0.0",
    "WolframVersion"   -> "11.0+",
    "Category"         -> "Engineering",
    "Keywords"         -> { "cross section", "moment of inertia", "torsion", "structural", "FEM" },
    "Extensions"       -> {
        {
            "Kernel",
            "Root"    -> "Kernel",
            "Context" -> { "CrossSectionTools`" },
            "Symbols" -> {
                "CrossSectionTools`CrossSection",
                "CrossSectionTools`TorsionConstant"
            }
        },
        {
            "Documentation",
            "Root"     -> "Documentation",
            "Language" -> "English"
        },
        {
            "Asset",
            "Assets" -> {
                { "License",  "./LICENSE"   },
                { "ReadMe",   "./README.md" },
                { "Examples", "./Examples"  }
            }
        }
    }
|> ]
