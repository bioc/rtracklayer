\name{BEDFile-class}
\docType{class}

%% Classes:
\alias{class:BEDFile}
\alias{class:BED15File}
\alias{class:BEDGraphFile}
\alias{class:NarrowPeakFile}
\alias{class:BroadPeakFile}
\alias{BEDFile-class}
\alias{BED15File-class}
\alias{BEDGraphFile-class}
\alias{BEDPEFile-class}
\alias{NarrowPeakFile-class}
\alias{BroadPeakFile-class}

%% Constructor:
\alias{BEDFile}
\alias{BED15File}
\alias{BEDGraphFile}
\alias{BEDPEFile}
\alias{NarrowPeakFile}
\alias{BroadPeakFile}

%% Import:
\alias{import,BEDFile,ANY,ANY-method}
\alias{import,BED15File,ANY,ANY-method}
\alias{import,BEDPEFile,ANY,ANY-method}
\alias{import,NarrowPeakFile,ANY-method}
\alias{import,BroadPeakFile,ANY-method}
\alias{import,NarrowPeakFile,ANY,ANY-method}
\alias{import,BroadPeakFile,ANY,ANY-method}
\alias{import.bed}
\alias{import.bed,ANY-method}
\alias{import.bed15}
\alias{import.bed15,ANY-method}
\alias{import.bedGraph}
\alias{import.bedGraph,ANY-method}
\alias{import.NarrowPeak}
\alias{import.NarrowPeak,ANY-method}
\alias{import.BroadPeak}
\alias{import.BroadPeak,ANY-method}

%% Export:
\alias{export,ANY,BEDFile,ANY-method}
\alias{export,GenomicRanges,BEDFile,ANY-method}
\alias{export,GRangesList,BEDFile,ANY-method}
\alias{export,GenomicRangesList,BEDFile,ANY-method}
\alias{export,UCSCData,BEDFile,ANY-method}
\alias{export,GenomicRanges,BED15File,ANY-method}
\alias{export,ANY,BEDPEFile,ANY-method}
\alias{export,Pairs,BEDPEFile,ANY-method}
\alias{export,UCSCData,BED15File,ANY-method}
\alias{export.bed}
\alias{export.bed,ANY-method}
\alias{export.bed15}
\alias{export.bed15,ANY-method}
\alias{export.bedGraph}
\alias{export.bedGraph,ANY-method}

\title{BEDFile objects}

\description{
  These functions support the import and export of the UCSC BED
  format and its variants, including BEDGraph.
}

\usage{
\S4method{import}{BEDFile,ANY,ANY}(con, format, text, trackLine = TRUE,
                   genome = NA, colnames = NULL,
                   which = NULL, seqinfo = NULL, extraCols = character(),
                   sep = c("\t", ""), na.strings=character(0L))
import.bed(con, ...)
import.bed15(con, ...)
import.bedGraph(con,  ...)

\S4method{export}{ANY,BEDFile,ANY}(object, con, format, ...)
\S4method{export}{GenomicRanges,BEDFile,ANY}(object, con, format,
                  append = FALSE, index = FALSE,
                  ignore.strand = FALSE, trackLine = NULL)
\S4method{export}{UCSCData,BEDFile,ANY}(object, con, format,
                   trackLine = TRUE, ...)
export.bed(object, con, ...)
export.bed15(object, con, ...)
\S4method{export}{GenomicRanges,BED15File,ANY}(object, con, format,
                  expNames = NULL, trackLine = NULL, ...)
export.bedGraph(object, con, ...)
}

\arguments{
  \item{con}{A path, URL, connection or \code{BEDFile} object. For the
    functions ending in \code{.bed}, \code{.bedGraph} and \code{.bed15},
    the file format is indicated by the function name. For the base
    \code{export} and \code{import} functions, the format must be
    indicated another way. If \code{con} is a path, URL or connection,
    either the file extension or the \code{format} argument needs to be
    one of \dQuote{bed}, \dQuote{bed15}, \dQuote{bedGraph},
    \dQuote{bedpe}, \dQuote{narrowPeak}, or
    \dQuote{broadPeak}. Compressed
    files (\dQuote{gz}, \dQuote{bz2} and
    \dQuote{xz}) are handled transparently.
  }
  \item{object}{The object to export, should be a \code{GRanges} or
    something coercible to a \code{GRanges}. If targeting the BEDPE
    format, this should be something coercible to \code{Pairs}.
    If the object has a method
    for \code{asBED} (like \code{GRangesList}), it is called prior to
    coercion. This makes it possible to export a \code{GRangesList} or
    \code{TxDb} in a way that preserves the hierarchical
    structure. For exporting multiple tracks, in the UCSC track line
    metaformat, pass a \code{GenomicRangesList}, or something coercible to
    one.
  }
  \item{format}{If not missing, should be one of \dQuote{bed},
    \dQuote{bed15}, \dQuote{bedGraph}, \dQuote{bedpe},
  \dQuote{narrowPeak} or \dQuote{broadPeak}.}
  \item{text}{If \code{con} is
    missing, a character vector to use as the input}
  \item{trackLine}{For import, an imported track line will be stored
    in a \code{\linkS4class{TrackLine}} object, as part of the returned
    \code{\linkS4class{UCSCData}}.  For the UCSCData method on export,
    whether to output the UCSC track line stored on the object, for the
    other export methods, the actual TrackLine object to export.
  }
  \item{genome}{The identifier of a genome, or a \code{Seqinfo}, or \code{NA} if
    unknown. Typically, this is a UCSC identifier like \dQuote{hg19}. An
    attempt will be made to derive the \code{seqinfo} on the return
    value using either an installed BSgenome package or UCSC, if network
    access is available.
  }
  \item{colnames}{A character vector naming the columns to parse. These
    should name columns in the result, not those in the BED spec, so
    e.g. specify \dQuote{thick}, instead of \dQuote{thickStart}.
  }
  \item{which}{A \code{GRanges} or other range-based object supported
    by \code{\link[IRanges]{findOverlaps}}. Only the intervals in the file
    overlapping the given ranges are returned. This is much more efficient
    when the file is indexed with the tabix utility.
  }
  \item{index}{If \code{TRUE}, automatically compress and index the
    output file with bgzf and tabix. Note that tabix indexing will
    sort the data by chromosome and start. Tabix supports a
    single track in a file.
  }
  \item{ignore.strand}{Whether to output the strand when not required
    (by the existence of later fields).
  }
  \item{seqinfo}{If not \code{NULL}, the \code{Seqinfo} object to set on
    the result. Ignored if \code{genome} is a \code{Seqinfo} object.
    If the \code{genome} argument is not \code{NA}, it must
    agree with \code{genome(seqinfo)}.
  }
  \item{extraCols}{A character vector in the same form as
    \code{colClasses} from \code{\link{read.table}}.  It should indicate
    the name and class of each extra/special column to read from the BED
    file. As BED does not encode column names, these are assumed to be
    the last columns in the file. This enables parsing of the various
    BEDX+Y formats.
  }
  \item{sep}{A character vector with a single character indicating the
    field separator, like \code{read.table}. This defaults to
    \code{"\t"}, as BEDtools requires, but BED files are also allowed to
    be whitespace separated (\code{""}) according to the UCSC spec.
  }
  \item{na.strings}{Character vector with strings, appended to the
    standard \code{"."}, that represent an \code{NA} value.
  }
  \item{append}{If \code{TRUE}, and \code{con} points to a file path,
    the data is appended to the file. Obviously, if \code{con} is a
    connection, the data is always appended.
  }
  \item{expNames}{character vector naming columns in
    \code{mcols(object)} to export as data columns in the BED15
    file. These correspond to the sample names in the experiment. If
    \code{NULL} (the default), there is an attempt to extract these from
    \code{trackLine}. If the attempt fails, no scores are exported.
  }
  \item{...}{Arguments to pass down to methods to other methods. For
    import, the flow eventually reaches the \code{BEDFile} method on
    \code{import}. When \code{trackLine} is
    \code{TRUE} or the target format is BED15, the arguments are passed
    through \code{export.ucsc}, so track line parameters are supported.
  }
}

\value{
  For a \dQuote{bedpe} file, a \code{Pairs} object combining two
  \code{GRanges}. The \code{name} and \code{score} are carried over to
  the metadata columns.

  Otherwise, a \code{GRanges} with the metadata columns described in the
  details.
}

\details{
  The BED format is a tab-separated table of intervals, with annotations
  like name, score and even sub-intervals for representing alignments and
  gene models. Official (UCSC) child formats currently include BED15
  (adding a number matrix for e.g. expression data across multiple samples)
  and BEDGraph (a compressed means of storing a single score variable, e.g.
  coverage; overlapping features are not allowed). Many tools and
  organizations have extended the BED format with additional columns for
  particular use cases. The
  advantage of BED is its balance between simplicity and expressiveness. It
  is also relatively scalable, because only the first three columns (chrom,
  start and end) are required. Thus, BED is best suited for representing
  simple features. For specialized cases, one is usually better off with
  another format. For example, genome-scale vectors belong in
  \link[=BigWigFile]{BigWig}, alignments from high-throughput sequencing
  belong in \link[Rsamtools:BamFile]{BAM}, and gene models are more richly
  expressed in \link[=GFFFile]{GFF}.

  The following is the mapping of BED elements to a \code{GRanges} object.
  NA values are allowed only where indicated.
  These appear as a \dQuote{.} in the file. Only the first three columns
  (chrom, start and strand) are required. The other columns can only be
  included if all previous columns (to the left) are included. Upon export,
  default values are used to automatically pad the table, if necessary.
  \describe{
    \item{chrom, start, end}{the \code{ranges} component.}
    \item{name}{character vector (NA's allowed) in the \code{name}
      column; defaults to NA on export.
    }
    \item{score}{numeric vector in the \code{score}
      column, accessible via the \code{score} accessor. Defaults to 0
      on export. This is the only column present in BEDGraph (besides
      chrom, start and end), and it is required.
    }
    \item{strand}{strand factor (NA's allowed) in the \code{strand}
      column, accessible via the \code{strand} accessor; defaults to NA
      on export.
    }
    \item{thickStart, thickEnd}{\code{IntegerRanges} object in a
      column named \code{thick}; defaults to the ranges of the feature
      on export.
    }
    \item{itemRgb}{an integer matrix of color codes, as returned by
      \code{\link{col2rgb}}, or any valid input to
      \code{\link{col2rgb}}, in the \code{itemRgb} column; default is NA
      on export, which translates to black.
    }
    \item{blockSizes, blockStarts, blockCounts}{\code{IntegerRangesList}
      object in a column named \code{blocks}; defaults to empty upon BED15
      export.
    }
  }

  For BED15 files, there should be a column of scores in
  \code{mcols(object)} for each sample in the experiment. The columns
  are named according to the \code{expNames} (found in the file, or
  passed as an argument during export). \code{NA} scores are stored as
  \dQuote{-10000} in the file.
}

\section{BEDX+Y formats}{
  To import one of the multitude of BEDX+Y formats, such as those used
  to distribute ENCODE data through UCSC (narrowPeaks, etc), specify
  the \code{extraCols} argument to indicate the expected names and
  classes of the special columns. We assume that the
  last \code{length(extraCols)} columns are special, and that the
  preceding columns adhere to the BED format. \dQuote{narrowPeak}
  and \dQuote{broadPeak} types are handled explicitly by specifying
  these types as the \code{format} argument, rather than by
  using \code{extraCols}.
}

\section{BEDFile objects}{
  The \code{BEDFile} class extends \code{\link[BiocIO:BiocFile-class]{BiocFile}} and is a
  formal represention of a resource in the BED format.
  To cast a path, URL or connection to a \code{BEDFile}, pass it to
  the \code{BEDFile} constructor. Classes and constructors also exist
  for the subclasses \code{BED15File}, \code{BEDGraphFile} and
  \code{BEDPEFile}.
}

\author{Michael Lawrence}

\references{
  \url{https://genome.ucsc.edu/goldenPath/help/customTrack.html}
  \url{http://bedtools.readthedocs.org/en/latest/content/general-usage.html}
}

\examples{
  test_path <- system.file("tests", package = "rtracklayer")
  test_bed <- file.path(test_path, "test.bed")

  test <- import(test_bed)
  test

  test_bed_file <- BEDFile(test_bed)
  import(test_bed_file)

  test_bed_con <- file(test_bed)
  import(test_bed_con, format = "bed")

  import(test_bed, trackLine = FALSE)
  import(test_bed, genome = "hg19")
  import(test_bed, colnames = c("name", "strand", "thick"))

  which <- GRanges("chr7:1-127473000")
  import(test_bed, which = which)

  bed15_file <- file.path(test_path, "test.bed15")
  bed15 <- import(bed15_file)

\dontrun{
  test_bed_out <- file.path(tempdir(), "test.bed")
  export(test, test_bed_out)

  test_bed_out_file <- BEDFile(test_bed_out)
  export(test, test_bed_out_file)

  export(test, test_bed_out, name = "Alternative name")

  test_bed_gz <- paste(test_bed_out, ".gz", sep = "")
  export(test, test_bed_gz)

  export(test, test_bed_out, index = TRUE)
  export(test, test_bed_out, index = TRUE, trackLine = FALSE)

  bed_text <- export(test, format = "bed")
  test <- import(format = "bed", text = bed_text)

  test_bed15_out <- file.path(tempdir(), "test.bed15")
  export(bed15, test_bed15_out) # UCSCData knows the expNames
  export(as(bed15, "GRanges"), test_bed15_out, # have to specify expNames
         expNames=paste0("breast_", c("A", "B", "C")))
}
}

\keyword{methods}
\keyword{classes}
