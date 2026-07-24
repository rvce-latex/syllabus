# TeXstudio custom dictionary for syllabus.cls
# CWL file for RVCE syllabus class custom environments and macros
# --------------------------------------------

# === Global Preamble Commands ===
\Department[short name]{long name}
\MastersIn[short name]{long name}
\pgProgramName{name}

# --- Course Grouping ---
\begin{semester}{semester number}
\end{semester}

\begin{coregroup}
\end{coregroup}

\begin{coregroup*}
\end{coregroup*}

\begin{electivegroup}{common code}{common title}{group letter}
\end{electivegroup}

\begin{aegroup}{common code}
\end{aegroup}

\begin{definecourse}{course code}
\end{definecourse}

# --- Metadata Commands ---
\category{text}
\stream{text}
\commonto{text}
\bos{text}
\coursetitle[course type]{title}
\prerequisites{text}

# === Main.tex: Master Credits & Rubrics ===
\begin{credit}{course base type}
\end{credit}
\variantchar{char}
\Lcredit{number}
\Tcredit{number}
\Pcredit{number}
\CIEduration{in hours}
\SEEduration{in hours}
\LecDuration{in hours}
\TutDuration{in hours}
\PracDuration{in hours}
\CIELmarks{number}
\CIEPmarks{number}
\SEELmarks{number}
\SEEPmarks{number}

\begin{definecredits}
\end{definecredits}
\begin{CIErubrics}
\end{CIErubrics}
\Crubric[L/P]{qno}{contents}{marks}
\begin{SEE@Theory@rubrics}[duration]
\end{SEE@Theory@rubrics}
\begin{SEE@Practical@rubrics}
\end{SEE@Practical@rubrics}
\SrubricA{qno}{contents}{marks}
\SrubricB[L/P]{qno}{contents}{marks}
\Srubric{qno}{contents}{marks}

# === <course-code>.tex: Standalone Configuration ===
\initstandalone[bib file]{semester}{course index}
\inbpdocument
\outbpdocument

# === <course-code>.tex: Course Environment ===
\begin{course}{semester}{course index}
\end{course}

# === <course-code>.tex: Lecture Units ===
\begin{units}
\end{units}
\unit[hours]{content}

# === <course-code>.tex: Practicals & EL ===
\begin{practicals}
\end{practicals}
\practicetitle{title}
\practiceeltitle{title}
\practiceinstruction{instruction text}
\experiment[tag]{content}
\experiment{content}

# --- Sub-Practicals ---
\begin{subpracticals}
\end{subpracticals}
\subexperiment[tag]{content}
\subexperiment{content}

# === <course-code>.tex: Course Outcomes ===
\begin{courseoutcomes}
\end{courseoutcomes}
\co{content}

# === <course-code>.tex: References ===
\begin{references}
\end{references}
\reference{bibkey}

# === <course-code>.tex: Editable CIE Rubrics ===
\CIErubricA{rubric text}
\CIErubricB{rubric text}
\CIErubricC{rubric text}
\CIErubricD{rubric text}
\CIErubricE{rubric text}
\CIErubricF{rubric text}
\CIErubricG{rubric text}
\CIErubricH{rubric text}