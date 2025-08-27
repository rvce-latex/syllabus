# syllabus
This is the class file meant to create syllabus book.
1. Create a table of content containing course code, course title and its page number.
1. Supports adding references to the course, by adding citation in `Reference.bib` and using its corresponding cite key.

## Idea:
The process flow is given below
1. Define the courses in Main.tex file, with **course code**. Each course can be anyone of the 4 type: PO (Pratice only), LO (Lecture only), LT (Lecture with tutorial), LP (Lecture with practice).
```
\documentclass{syllabus}

\begin{document}
\begin{scheme}{3} % Scheme {3} defines the semester. Here we have defined 2 courses
\begin{definecourse}{ma121ai} % <ma121ai> is the course code
	\coursetitle[LO]{Elements of electronics}
\end{definecourse}
\begin{definecourse}{ec121ai}
	\coursetitle[LO]{Elements of electronics}
\end{definecourse}
\end{scheme}

\end{document}
```
2. Based on the course code, generate a template file named <course-code>.tex
```
	LP									LO							LT							PO
\begin{course}{1}                   \begin{course}{1}           \begin{course}{1}           \begin{course}{1}           
    \category{}                         \category{}                 \category{}                 \category{}             
    \commonto{}                         \commonto{}                 \commonto{}                 \commonto{}             
    \stream{}                           \stream{}                   \stream{}                   \stream{}               
    \ciemarks{}                         \ciemarks{}                 \ciemarks{}                 \ciemarks{}             
    \seemarks{}                         \seemarks{}                 \seemarks{}                 \seemarks{}             
    \seeduration{}                      \seeduration{}              \seeduration{}              \seeduration{}          
    \totalhours{}                       \totalhours{}               \totalhours{}               \totalhours{}           
    \prerequisites{}                    \prerequisites{}            \prerequisites{}            \prerequisites{}        
    \begin{units}                       \begin{units}               \begin{units}               \begin{practicals}           
        \unit[4]{sample}                    \unit[4]{sample}            \unit[4]{sample}            \practicetitle{Hardware}
    \end{units}                         \end{units}                 \end{units}                     \experiment{Design}             
    \begin{practicals}                  \begin{courseoutcomes}      \begin{courseoutcomes}          \practiceeltitle{Outcome}
        \practicetitle{Hardware}            \co{sample}                 \co{sample}                 \experiment[EL]{Design}
        \experiment{Design}             \end{courseoutcomes}        \end{courseoutcomes}        \end{practicals}
        \practiceeltitle{Outcome}       \begin{references}          \begin{references}          \begin{courseoutcomes}
        \experiment[EL]{Design}             \reference{Razavi2000}      \reference{Razavi2000}      \co{sample}
    \end{practicals}                    \end{references}            \end{references}            \end{courseoutcomes}
    \begin{courseoutcomes}          \end{course}                \end{course}                    \begin{references}
        \co{sample}                                                                                 \reference{Razavi2000}
    \end{courseoutcomes}                                                                        \end{references}
    \begin{references}                                                                      \end{course}
    %Add citation key defined in reference.bib file in the current directory
    %As an example, a predefined key is added here under \referencecommand.
        \reference{Razavi2000}
    \end{references}
\end{course}
```
3. The subject experts will define the course details like, unit-wise hours and contents for lecture, list of experiments for practice
4. Read the contents of <course-code>.tex and including practicals and store this information onto aux file.
5. Read the Data from aux file and build a table.

## Yet...
1. Need to add header and footer
2. Scheme table after toc page