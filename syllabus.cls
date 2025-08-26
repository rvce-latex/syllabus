% % \iffalse meta-comment
% % !TEX program  = pdfLaTeX

% %<*readme>
% ----------------------------------------------------------------
% syllabus --- This class is created for creating syllabus book for
%              RV college of Engineering.
% E-mail: narashimaraja@gmail.com; pnarashimaraja@rvce.edu.in
% Released under the LaTeX Project Public License v1.3c or later
% See https://www.latex-project.org/lppl.txt
% ----------------------------------------------------------------

% This syllabus class creates a tex file based on the coursecode defined 
% by the department BoS and the syllabus is defined individually by subject 
% experts in the tex file.
% %</readme>

% Used while compiling and creating log information
% %<*package>
\def\fileversion{1.0}
\def\filedate{2025/08/05}

%% Starting point of class
\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{syllabus}[\filedate\space Version \fileversion\space by P Narashimaraja]
%%</package>

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}

% Packages required for table and control making
\RequirePackage{ifthen}
\RequirePackage{longtable}
\RequirePackage{pgf}
\RequirePackage{pgffor}
% Helper: Convert to uppercase
\RequirePackage{textcase} % for \MakeTextUppercase
\RequirePackage{array}
\RequirePackage{enumitem}

% -------------------- Page setup ---------------------------
\setlength{\oddsidemargin}{-0.25in}
\setlength{\evensidemargin}{-0.25in}
\setlength{\textwidth}{6in}
\setlength{\topmargin}{-0.25in}
\setlength{\textheight}{9.5in}

% -------------------- Definitions ---------------------------
%% Conditional ifs
\newif\ifprerequisite
\newif\ifpractice
\newif\ifpracticeel
\newif\iftutorial
\newif\iflecture
% Defaults:
\prerequisitefalse
\practicefalse
\practiceelfalse
\tutorialfalse
\lecturefalse

%% Counters
\newcounter{latest@course}
\newcounter{numof@courses}
\newcounter{numof@schemes}
\setcounter{numof@schemes}{0}
% Templated
\newcounter{numof@prerequisites}
\newcounter{numof@lectureunits}
\newcounter{numof@practiceunits}
\newcounter{numof@practiceelunits}
\newcounter{numof@coursecos}
\newcounter{temp@counter}

%% Environment
\newwrite\coursefile
\newread\readcoursefile

% ------------------------------------------------------------
\newcommand\checkint[1]{%
    \ifnum#1=\numexpr#1\relax
        \typeout{#1 is an integer.}%
        \ifnum#1>3\relax
          \ClassError{syllabus}{#1 is not a valid integer.\MessageBreak}{Use 1 :For Theory; 2 :For Theory+Lab; 3 :For Practical alone.\MessageBreak}%
        \fi
    \else
        \ClassError{syllabus}{#1 is not an integer}{}%
    \fi
}

%% Type definitions
% course type
\def\po{PO}
\def\lo{LO}
\def\lt{LT}
\def\lp{LP}
\def\EL{EL}
\newcommand\checkcoursetype[1]{%
  \edef\coursetypeupper{#1}%
  \ifx\coursetypeupper\po\relax
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@lecturestatus{0}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@practicestatus{1}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@tutorialstatus{0}}
    \def\ltp{{0,0,2}}
    \typeout{From PO type, the status of L:\iflecture 1\else 0\fi, T:\iftutorial 1\else 0\fi\space and\space\ifpractice 1\else 0\fi. }
  \else\ifx\coursetypeupper\lo\relax
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@lecturestatus{1}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@practicestatus{0}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@tutorialstatus{0}}
    \def\ltp{{4,0,0}}
    \typeout{From LO type, the status of L:\iflecture 1\else 0\fi, T:\iftutorial 1\else 0\fi\space and\space\ifpractice 1\else 0\fi. }
  \else\ifx\coursetypeupper\lt\relax
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@lecturestatus{1}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@practicestatus{0}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@tutorialstatus{1}}
    \def\ltp{{3,1,0}}
    \typeout{From LT type, the status of L:\iflecture 1\else 0\fi, T:\iftutorial 1\else 0\fi\space and\space\ifpractice 1\else 0\fi. }
  \else\ifx\coursetypeupper\lp\relax
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@lecturestatus{1}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@practicestatus{1}}
    \immediate\write\@mainaux{\string\gdef\string\course@\romannumeral\value{numof@courses}@tutorialstatus{0}}
    \def\ltp{{3,0,1}}
    \typeout{From LP type, the status of L:\iflecture 1\else 0\fi, T:\iftutorial 1\else 0\fi\space and\space\ifpractice 1\else 0\fi. }
  \else\ifx\coursetypeupper\EL\relax
    % OK
  \else
    \ClassError{syllabus}{Invalid course type `#1'. Must be PO or LO or LT or LP or EL}{}%
  \fi\fi\fi\fi\fi
%   \fi
}

% practice type
\def\EL{EL}
\newcommand\checkpracticeeltype[1]{%
  \edef\coursetypeupper{#1}%
  % \edef\coursetypeupper{\MakeTextUppercase{#1}}%
  \ifx\coursetypeupper\EL\relax
    \practiceeltrue
    % \def\ltp{{0,0,2}}
    % OK
  \else
    \ClassError{syllabus}{Invalid course type `#1'. Must be PO or LO or LT or LP or EL}{}%
  \fi
}

% course unit type
\newcommand\checkunithour[1]{%
    \ifnum#1=\numexpr#1\relax
        \typeout{#1 is an integer.}%
    \else
        \ClassError{syllabus}{#1 is not an integer}{}%
    \fi
}
% ------------------------------------------------------------

%--------------------------------------------------------------------
%				\PgInfo, \PgInfo@write and \PgInfo@get

\def\PgInfo@write#1{%
  \begingroup
    \edef\reserved@a{\write\@mainaux
      {\string\PgInfo{#1}{\noexpand\thepage}}}% \noexpand\thepage: delays expansion of \thepage until actual write time (so you get the current page number, not the number during \edef)
      % \string\PgInfo -> literal string \PgInfo
      %% \write\@mainaux{\string\PgInfo{mylabel}{\noexpand\thepage}} -> \write\@mainaux{\PgInfo{mylabel}{<current page>}}
    \reserved@a% Calls \reserved@a, which actually performs the \write
  \endgroup
}

\def\PgInfo#1#2{\expandafter\gdef\csname Pg@#1\endcsname{#2}}
% When LaTeX rereads the .aux file, this gets executed: "\PgInfo{Q1}{5}", which defines the control sequence \Pg@Q1 as: "\gdef\Pg@Q1{5}"
\def\PgInfo@get#1{\csname Pg@#1\endcsname}
% \PgInfo@get{Q1} → \csname Pg@Q1\endcsname → expands to 5
%--------------------------------------------------------------------
%----------------- newtoks -------------------------
% In TeX, \toks registers (short for token list registers) are used to store sequences of tokens, i.e., the input text as parsed by TeX before expansion. 
% They're very useful for temporarily holding macro arguments, code snippets, or even building complex constructions that are to be evaluated later.
\newtoks\pageinfo@commands
\newtoks\lecturerowstok

% \pagepoint@commands holds the commands to manage the counting of the number of points defined on each page.
\newtoks\pagepoint@commands

% \point@toks holds the commands to print the points at the proper location on the page (except that it's not used by the \qformat option).
\newtoks\point@toks
%------------------------------- [if] stmt-------------------------------------
\newif\if@includecourse
\@includecoursefalse
%--------------------------------------------------------------------

\newenvironment{scheme}[1]{%
  % Environment for courses
  \edef\sem{#1}
  \addtocounter{numof@schemes}{1}
  % Defaults
  \setcounter{numof@courses}{0}
  \begingroup
      \newenvironment{definecourse}[1]{%
        \addtocounter{numof@courses}{1}
        \gdef\course@code{##1}
        % Defaults - Move it to course environment
        \practiceelfalse
        \setcounter{numof@lectureunits}{0}
        \setcounter{numof@practiceunits}{0}
        \setcounter{numof@practiceelunits}{0}
        \setcounter{numof@coursecos}{0}
        \def\coursetitle{
            % \edef\thecoursetitle{p@course\value{numof@courses}}
            \process@course
          }
        \def\process@course{%
          % \pageinfo@commands={%
          %   \edef\@courselabel{course@\arabic{numof@courses}}%
          %   \PgInfo@write{\@courselabel}%
          %   \begingroup % to confine the change to \@currentlabel
          %     \def\@currentlabel{\thecoursetitle}%
          %     \label{\@courselabel}%
          %   \endgroup
          %   \the\pagepoint@commands
          %   \global \pageinfo@commands={}%
          % }% pageinfo@commands
          \ifhmode
            % Remove any skips at the end of the previous paragraph that might cause a blank line, and then end that paragraph:
            \unskip\unskip \par
          \fi
          \@docourse
        }% process@course
      }% End of 1st argument of definecourse environment
      {
        \IfFileExists{\course@code}{
          % Do Nothing
        }{
          % \edef\percentagechar{\string%}
          \expandafter\immediate\openout\coursefile=\course@code.tex
          % \immediate\openout\writecode=temp.csv
          \immediate\write\coursefile{\string\begin{course}{\arabic{numof@courses}}}
          \immediate\write\coursefile{\space\string\category{}}
          \immediate\write\coursefile{\space\string\commonto{}}
          \immediate\write\coursefile{\space\string\stream{}}
          \immediate\write\coursefile{\space\string\ciemarks{}}
          \immediate\write\coursefile{\space\string\seemarks{}}
          \immediate\write\coursefile{\space\string\seeduration{}}
          \immediate\write\coursefile{\space\string\totalhours{}}
          \immediate\write\coursefile{ \@percentchar\string To change subjectwise credits, uncomment the following commands}
          \iflecture
            \immediate\write\coursefile{ \@percentchar\string\lecturecredit{}}
          \fi
          \iftutorial
            \immediate\write\coursefile{ \@percentchar\string\tutorialcredit{}}
          \fi
          \ifpractice
            \immediate\write\coursefile{ \@percentchar\string\practicecredit{}}
          \fi
          %
          \immediate\write\coursefile{ \@percentchar\string\prerequisites{}}
          \iflecture
            \immediate\write\coursefile{\space\string\begin{units}}
            \immediate\write\coursefile{\space\space\string\unit[4]{sample}}
            \immediate\write\coursefile{\space\string\end{units}}
          \fi
          \ifpractice
            \immediate\write\coursefile{\space\string\begin{practicals}}
            \immediate\write\coursefile{\space\space\string\practicetitle{Hardware experiments}}
            \immediate\write\coursefile{\space\space\string\experiment{Design}}
            \immediate\write\coursefile{\space\space\string\practiceeltitle{Innovative Experiments}}
            \immediate\write\coursefile{\space\space\string\experiment[EL]{For EL experiment}}
            \immediate\write\coursefile{\space\string\end{practicals}}
          \fi
          \immediate\write\coursefile{\string\end{course}}
          % \writecourseheader
          \immediate\closeout\coursefile
        }
      }% End of 2ndargument of definecourse environment
}% End of 1st argument of scheme environment
{% 2nd argument of scheme environment
\endgroup
% Write the final number of courses inside the scheme environment
  \immediate\write\@mainaux
        {\string\gdef\string\thenumof@courses{\arabic{numof@courses}}}%
}% End of 2nd argument of scheme environment

\newenvironment{course}[1]{%
  \def\courseindex{#1}
  \pgfmathsetmacro{\mya}{\expandafter{\csname course@\romannumeral#1@courseltp\endcsname[0]}}
  \pgfmathsetmacro{\myb}{\expandafter{\csname course@\romannumeral#1@courseltp\endcsname[1]}}
  \pgfmathsetmacro{\myc}{\expandafter{\csname course@\romannumeral#1@courseltp\endcsname[2]}}
  \typeout{The value of lcredit is:\space\mya,\space\myb,\space\myc}
  \setcounter{numof@lectureunits}{0}
  \setcounter{numof@practiceunits}{0}
  \setcounter{numof@practiceelunits}{0}
%   \xdef\lcredit{\course@\romannumeral\csname courseindex\endcsname @courseltp[1]}
  % \xdef\tcredit{\course@\romannumeral\csname courseindex\endcsname @courseltp[2]}
  % \xdef\pcredit{\course@\romannumeral\csname courseindex\endcsname @courseltp[3]}
  \newcommand*{\numofcos}[1][4]{##1}%
  \newcommand*{\lecturecredit}[1]{\immediate\write\@mainaux{\string\gdef\string\course@\romannumeral#1@courseltp{{##1,\myb,\myc}}}}%
  \newcommand*{\tutorialcredit}[1]{\immediate\write\@mainaux{\string\gdef\string\course@\romannumeral#1@courseltp{{\mya,##1,\myc}}}}%
  \newcommand*{\practicecredit}[1]{\immediate\write\@mainaux{\string\gdef\string\course@\romannumeral#1@courseltp{{\mya,\myb,##1}}}}%
  \def\category##1{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@category{##1}}}%
%   \newcommand*{\category}[1]{\def\@category{##1}}%
  \newcommand*{\commonto}[1]{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@commonto{##1}}}%
  \newcommand*{\stream}[1]{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@stream{##1}}}%
%   \newcommand*{\stream}[1]{\\immediate\write\@mainaux
%     {\string\gdef\string\course@\romannumeral#1@stream{##1}}}%
  \newcommand*{\ciemarks}[1]{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@ciemarks{##1}}}%
  \newcommand*{\seemarks}[1]{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@seemarks{##1}}}%
  \newcommand*{\seeduration}[1]{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@seeduration{##1}}}%
  \newcommand*{\totalhours}[1]{\immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral#1@totalhours{##1}}}%
  \newcommand*{\prerequisites}[1]{
    \def\@temp{#1}
    \def\@spaces{ }
    \ifx\@temp\@empty
      \global\prerequisitefalse
    \else
      \ifx\@temp\@spaces
        \global\prerequisitefalse
      \else
        \global\prerequisitetrue 
        \def\@prerequisites{#1}%
      \fi
    \fi
  }%
%   \begingroup 
    \newenvironment{units}{
      \def\unit{%
        % \addtocounter{numof@lectureunits}{1}
         \ifhmode
          % Remove any skips at the end of the previous paragraph that might cause a blank line, and then end that paragraph:
          \unskip\unskip \par
        \fi
        \@dounit
      }
    }% End of 1st arg of units environment
    { }% End of 2nd arg of units environment
    % 
    \newenvironment{practicals}{
        % \def\dumpindex{#1}
      \def\practicetitle####1{%
        \immediate\write\@mainaux
            {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @practicetitle{####1}}%
        }%
      \def\practiceeltitle####1{%
        \immediate\write\@mainaux
            {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @practiceeltitle{####1}}%
        }%
    %   \def\practiceeltitle####1{\def\@practiceeltitle{####1}}%
      \def\experiment{%
         \ifhmode
          % Remove any skips at the end of the previous paragraph that might cause a blank line, and then end that paragraph:
          \unskip\unskip \par
        \fi
        \@dopractice%
      }
    }% End of 1st arg of units environment
    { }% End of 2nd arg of units environment
}% End of 1st argument of course environment
{
  \ifprerequisite
    \immediate\write\@mainaux
      {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @prerequisites{\@prerequisites}}%
  \fi% prerequisite

  %% Total number of lecture units
  \immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @numoflectureunits{\arabic{numof@lectureunits}}}%
  \immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @numofpracticeunits{\arabic{numof@practiceunits}}}%
  \immediate\write\@mainaux
    {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @numofpracticeelunits{\arabic{numof@practiceelunits}}}%
%   \immediate\write\@mainaux
%     {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @pgnum{\noexpand\thepage}}%
    \protected@write\@auxout{}{\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @pgnum{\thepage}}
}
%--------------------------------@doitem[def]-----------------------------
\def\@docourse{\@ifnextchar[{\@readpoints}%
                          {\ClassError{syllabus}{Provide Type and Category of the course.\MessageBreak
                          }{%
                            1 must be integer (1 :for Theory alone; 2 :For Theory+Lab; 3 :For Practical alone)\MessageBreak
                            2 must be one of the option(PR :for Professional course, EL :for Elective course)\MessageBreak
                            }
                          }%
}
\def\@dounit{\@ifnextchar[{\@readunits}%
                          {\ClassError{syllabus}{Provide Type and Category of the course.\MessageBreak
                          }{%
                            1 must be integer (1 :for Theory alone; 2 :For Theory+Lab; 3 :For Practical alone)\MessageBreak
                            2 must be one of the option(PR :for Professional course, EL :for Elective course)\MessageBreak
                            }
                          }%
}
\def\@dopractice{\@ifnextchar[{\@readpracticeel}%
                          {\@readpractice}%
}
%-------------------------------@readpoints[#1]---------------------------
\def\@readpoints[#1]#2{% #2: define course title
  \def\@type{#1}% PO, LO, LP, LT
  \checkcoursetype{\@type}
  
  \if@filesw
    % Store all Data
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\value{numof@courses}@coursesem{\sem}}%
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\value{numof@courses}@coursecode{\course@code}}%
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\value{numof@courses}@coursetype{#1}}%
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\value{numof@courses}@coursetitle{#2}}%
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\value{numof@courses}@courseltp{\ltp}}%
  \fi
}% @readpoints

\def\@readunits[#1]#2{%
  \def\@type{#1}
  \checkunithour{\@type}
  \addtocounter{numof@lectureunits}{1}
  \if@filesw
    % Store all Data
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @lectureunit@\roman{numof@lectureunits}@hour{#1}}%
      % \edef\tmp{\course@\romannumeral\csname courseindex\endcsname @lectureunit@\roman{numof@lectureunits}@content}
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @lectureunit@\roman{numof@lectureunits}@content{\unexpanded{#2}}}%
  \fi
}% @readunits

\def\@readpracticeel[#1]#2{%
  \def\@type{#1}
  \def\@category{#2}
  \checkpracticeeltype{\@type}
  \addtocounter{numof@practiceelunits}{1}
  \global\practiceeltrue
  \if@filesw
    % Store all Data
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @practiceelunitcontent@\roman{numof@practiceelunits}{#2}}%
  \fi
}% @readpracticeel

\def\@readpractice#1{%
  \addtocounter{numof@practiceunits}{1}
  \if@filesw
    \immediate\write\@mainaux
        {\string\gdef\string\course@\romannumeral\csname courseindex\endcsname @practiceunitcontent@\roman{numof@practiceunits}{#1}}%
  \fi
}% @readpractice

%----------------Template commands------------------------------

\newcommand{\xpandtable}[5]{%
  \begingroup
  \def\@scartchlectable##1{%
    % \iflecture
    % {%
      \unexpanded{%
        \begin{tabular}{p{\dimexpr0.8\textwidth-2\tabcolsep-1.8\arrayrulewidth\relax}|%
                        >{\raggedleft\arraybackslash}p{\dimexpr0.2\textwidth-2\tabcolsep-1.2\arrayrulewidth\relax}%
                      }%
        \hline
        \centering
      }%
      {\unexpanded{\textbf{\unexpanded{Unit - \MakeTextUppercase}{\romannumeral##1}}}}
      \unexpanded{%
        &%
        \textbf
      }{%
        \unexpanded{\expandafter{\csname course@\romannumeral#1@lectureunit@\romannumeral##1@hour\endcsname}}%
      }
      \unexpanded{%
        \\%
        \hline
        % 
        \multicolumn{2}{p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}}%
      }{%
      \unexpanded{\begin{minipage}[b]{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}}
      \unexpanded{\setlist[itemize]{topsep=0pt,itemsep=0.125em}}
        \unexpanded{\expandafter{\csname course@\romannumeral#1@lectureunit@\romannumeral##1@content\endcsname}}
         \unexpanded{\end{minipage}}
      }%
      \unexpanded{%
        % \end{minipage}
      \\%
      % \hline
        \end{tabular}%
        \\%
      }%
  }% End of scartctable
  \def\@scartchpractable##1{%
    % \ifpractice
    % {%
      \unexpanded{%
        \item \expandafter{\csname course@\romannumeral#1@practiceunitcontent@\romannumeral##1\endcsname}%
      }%
  }% End of scartctable
  \expanded{% 
    \endgroup
    % #3%
      \unexpanded{%
        \begin{longtable}{|@{}l@{}|}%
        \hline
        \endfirsthead
        \hline
        \endhead
        \hline
        \endfoot
        \hline
        \endlastfoot
      }%
      \unexpanded{%
        \begin{tabular}{>{\centering\arraybackslash}p{\dimexpr\textwidth\relax}}%
            \hline
          \textbf
      }%
      {\unexpanded{Semester - \printsemester}}%%check for \expandafter
      \unexpanded{%
        \\%
        \hline%
          \textbf
      }%
      {\unexpanded\expandafter{\csname course@\romannumeral#1@coursetitle\endcsname}}
      \unexpanded{%
        \\%
          \textbf
      }%
      {\unexpanded\expandafter{\csname course@\romannumeral#1@category\endcsname}}
      \unexpanded{%
        \\%
          \textbf
      }%
      {\unexpanded\expandafter{\csname course@\romannumeral#1@stream\endcsname}}
      \unexpanded{%
        \\%
        \end{tabular}%
        \\%
      }%
      \unexpanded{%
        \begin{tabular}{p{\dimexpr0.2\textwidth-\tabcolsep-0.4\arrayrulewidth\relax}|%
                        p{\dimexpr0.2\textwidth-\tabcolsep-0.4\arrayrulewidth\relax}|%
                        p{\dimexpr0.2\textwidth-\tabcolsep-0.4\arrayrulewidth\relax}|%
                        p{\dimexpr0.2\textwidth-\tabcolsep-0.4\arrayrulewidth\relax}|%
                        p{\dimexpr0.2\textwidth-\tabcolsep-0.4\arrayrulewidth\relax}}%
      \hline%
      \textbf{Course Code}&\textbf{:}\space\MakeTextUppercase{\csname course@\romannumeral#1@coursecode\endcsname} & & \textbf{CIE} & \textbf{:}\space{\csname course@\romannumeral#1@ciemarks\endcsname}\space Marks\\%
      \textbf{Credit\space L:T:P}&\textbf{:}\space{\csname course@\romannumeral#1@courseltp\endcsname} & & \textbf{SEE} & \textbf{:}\space{\csname course@\romannumeral#1@seemarks\endcsname}\space Marks\\%
      \textbf{Total Hours}&\textbf{:}\space{\csname course@\romannumeral#1@totalhours\endcsname} & & \textbf{SEE Duration} & \textbf{:}\space{\csname course@\romannumeral#1@seeduration\endcsname}\space Hours\\%
      \hline%
      }
      \unexpanded{%
        \end{tabular}%
        \\
      }%
    %wnd of%3#
    \iflecture
        \ifnum#2<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
            {
                \expandafter\@lecloop
                \expandafter{\number\numexpr(1)\expandafter\relax\expandafter}%
                \expandafter{\number\numexpr(#2)\relax}%
            }
    % \global\lecturefalse
    \fi
    \ifpractice
        \ifnum#3<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
            {\unexpanded{%
            \hline
            \begin{tabular}{>{\raggedright\arraybackslash}p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}}
            \textbf
            }%course@\romannumeral\csname courseindex\endcsname @practiceeltitle
            {\unexpanded{\expandafter{\csname course@\romannumeral#1@practicetitle\endcsname}}}
            \unexpanded{%
            \setlist[enumerate]{topsep=0em,itemsep=0.125em}
            \begin{enumerate}
            }%
            \expandafter\@pracloop
            \expandafter{\number\numexpr(1)\expandafter\relax\expandafter}%
            \expandafter{\number\numexpr(#3)\relax}%
            \unexpanded{%
                \end{enumerate}
            % \end{minipage}
                \end{tabular}%
            \\%
            }
        }
    \fi
    \ifpracticeel
        \ifnum#4<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
            {\unexpanded{%
            \hline
            \begin{tabular}{>{\raggedright\arraybackslash}p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}}
            \textbf
            }%course@\romannumeral\csname courseindex\endcsname @practiceeltitle
            {\unexpanded{\expandafter{\csname course@\romannumeral#1@practiceeltitle\endcsname}}}
            \unexpanded{%
            \setlist[enumerate]{topsep=0em,itemsep=0.125em}
            \begin{enumerate}
            }%
            \expandafter\@pracloop
            \expandafter{\number\numexpr(1)\expandafter\relax\expandafter}%
            \expandafter{\number\numexpr(#4)\relax}%
            \unexpanded{%
                \end{enumerate}
            % \end{minipage}
                \end{tabular}%
            \\%
            }
        }
    \fi

    %#5%
    \unexpanded{
      \ifhmode
      \\
      \fi
      \end{longtable}%
    }
  }%
}


\newcommand\@lecloop[2]{%
  \ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi
  {%
    \@scartchlectable{#1}%
    \expandafter\@lecloop\expandafter{\number\numexpr#1+1}{#2}%
  }%
}%
\newcommand\@pracloop[2]{%
  \ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi
  {%
    \@scartchpractable{#1}%
    \expandafter\@pracloop\expandafter{\number\numexpr#1+1}{#2}%
  }%
}%

%----------------------Main Idex Table-------------------------
\newcommand{\mainindextable}[1]{%
  \begingroup
  \def\@mainindextoc##1{%
    \unexpanded{%
      \begin{tabular}{>{\centering\arraybackslash}p{\dimexpr0.05\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}|%
                        >{\centering\arraybackslash}p{\dimexpr0.2\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}|%
                        p{\dimexpr0.75\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}|%
                                >{\centering\arraybackslash}p{\dimexpr0.1\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}%
                              }%
                \hline
                ##1. & \MakeTextUppercase{\expandafter{\csname course@\romannumeral##1@coursecode\endcsname}} & \expandafter{\csname course@\romannumeral##1@coursetitle\endcsname} & \expandafter\Pgnum{##1}\\
                % \x. & \MakeTextUppercase{\expanded{\csname course@\romannumeral\csname x\endcsname @coursecode\endcsname}} & \expanded{\csname course@\romannumeral\csname x\endcsname @coursetitle\endcsname} & \expandafter\Pgnum{##1}\\
      \end{tabular}\\
    }%
  }% End of scartctable
  \expanded{% 
    \endgroup
    % #3%
      \unexpanded{%
        \begin{longtable}{|@{}l@{}|}%
        \hline
        \endfirsthead
        \hline
        \endhead
        \hline
        \endfoot
        \hline
        \endlastfoot
      }%
      \unexpanded{
        \begin{tabular}{p{\dimexpr0.05\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}|%
                      p{\dimexpr0.2\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}|%
                      p{\dimexpr0.75\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}|%
                              >{\raggedleft\arraybackslash}p{\dimexpr0.1\textwidth-0.5\tabcolsep-0.25\arrayrulewidth\relax}%
                            }%
              \hline%
              \multicolumn{4}{p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}}%
                  {\centering{\textbf{\printsemester\space Semester}}}\\%
              \hline
              \centering{\textbf{SI}}&\centering{\textbf{Course Code}}&\centering{\textbf{Course Title}}& \centering{\textbf{Page No.}}\\
      \end{tabular}\\
      }
    %wnd of%3#
      \ifnum#1<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
          {
            \expandafter\@mainloop
            \expandafter{\number\numexpr(1)\expandafter\relax\expandafter}%
            \expandafter{\number\numexpr(#1)\relax}%
          }
    %#5%
    \unexpanded{
      \ifhmode
      \\
      \fi
      \end{longtable}%
    }
  }%
}

\newcommand\@mainloop[2]{%
  \ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi
  {%
    \@mainindextoc{#1}%
    \expandafter\@mainloop\expandafter{\number\numexpr#1+1}{#2}%
  }%
}%
% \def\Pgnum#1{\csname course@\romannumeral#1@pgnum\endcsname}
\def\Pgnum#1{%
%   \def\coursepagenumber{#1}%
  \@ifundefined{course@\romannumeral#1@pgnum}%
    {\mbox{\normalfont\bfseries ??}}%
    {\csname course@\romannumeral#1@pgnum\endcsname}
    % {\read@pgnum}%
}% pointsinrange
% \def\read@pgnum{\csname course@\romannumeral#1@pgnum\endcsname}
%----------------AtBeginDocument------------------------------
% \AtBeginDocument{%

% }
%----------------AtEndDocument------------------------------
\AtEndDocument{%
% \centering{\Large\textbf{\MakeTextUppercase{Index}}}
  \def\myX{1}
  % \def\x{2}
  \gdef\printsemester{\MakeTextUppercase{\romannumeral\csname course@\romannumeral\csname myX\endcsname @coursesem\endcsname}}
  \mainindextable{\arabic{numof@courses}}
  
  \foreach \x in {1,...,\arabic{numof@courses}}{%
    \edef\course@code{\csname course@\romannumeral\csname x\endcsname @coursecode\endcsname}
    \input{\course@code.tex}
    \edef\lecturestatus{\csname course@\romannumeral\csname x\endcsname @lecturestatus\endcsname}
    \edef\practicestatus{\csname course@\romannumeral\csname x\endcsname @practicestatus\endcsname}
    \edef\tutorialstatus{\csname course@\romannumeral\csname x\endcsname @tutorialstatus\endcsname}
    \ifnum\lecturestatus=1\relax
      \global\lecturetrue
    \else
      \global\lecturefalse
    \fi
    \ifnum\practicestatus=1\relax
      \global\practicetrue
    \else
      \global\practicefalse
    \fi
    \ifnum\tutorialstatus=1\relax
      \global\tutorialtrue
    \else
      \global\tutorialfalse
    \fi
    \edef\nlec{\csname course@\romannumeral\csname x\endcsname @numoflectureunits\endcsname}
	\edef\nprac{\csname course@\romannumeral\csname x\endcsname @numofpracticeunits\endcsname}
	\edef\npel{\csname course@\romannumeral\csname x\endcsname @numofpracticeelunits\endcsname}
    \clearpage% Forces a page break.
    \input{Template.tex}
    \typeout{The number of lecture units:\nlec\space\iflecture 1\else 0\fi, practice:\nprac\space\ifpractice 1\else 0\fi, practiceel:\npel\space\ifpracticeel 1\else 0\fi\space for the course:\course@code }
    % \input{temp.tex}
    % Reset after every page/course
    % \prerequisitefalse
    % \practicefalse
    % \practiceelfalse
    % \lecturefalse
  }
%   \clearpage% Forces a page break.
%     \input{Template.tex}
}% AtEndDocument

\endinput