# syllabus
This is the class file meant to create syllabus book.

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
    \begin{practicals}              \end{course}                \end{course}                        \practiceeltitle{Outcome}
        \practicetitle{Hardware}                                                                    \experiment[EL]{Design}
        \experiment{Design}                                                                     \end{practicals}
        \practiceeltitle{Outcome}                                                           \end{course}
        \experiment[EL]{Design}
    \end{practicals}
\end{course}
```
3. The subject experts will define the course details like, unit-wise hours and contents for lecture, list of experiments for practice
4. Read the contents of <course-code>.tex and including practicals and store this information onto aux file.
5. Define a Template.tex file, so that the date is read back from aux file and build a table.
```
\xpandtable{2}{2}{1}{1}{1}
```

## Features to be added:
1. Create a table of content containing course code, course title and its page number.
1. Need to add suppport for adding references to the course, which is based on cite key.
