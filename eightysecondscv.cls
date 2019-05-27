% EightySecondsCV LaTeX class 
% Author: Carles Estrada <estradacarles11@gmail.com>
%
% Attributions
% ------------
% * EightySecondsCV is based on the FortySecondsCV class by René Wirnata 
%   (rene.wirnata@pandascience.ne), which is based on the twentysecondcv class
%   by Carmine Spagnuolo (cspagnuolo@unisa.it), released under the MIT license
%   and available under:
%   https://github.com/spagnuolocarmine/TwentySecondsCurriculumVitae-LaTex
% * further attributions are indicated immediately before corresponding code


%-------------------------------------------------------------------------------
%                           CLASS NAME AND VERSION
%-------------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{eightysecondscv}[2019/05/23 CV class]


%-------------------------------------------------------------------------------
%                            PROCESS CLASS OPTIONS
%-------------------------------------------------------------------------------
%% load some required packages first

% for easy color definitions; provides \definecolor; load before background pkg
\RequirePackage[dvipsnames, svgnames, x11names]{xcolor}

% for positioning text within the side column | use showboxes for visible frame
\RequirePackage[absolute,overlay]{textpos}

% provides key-value class options via \DeclareOptionX
\RequirePackage{xkeyval}

% provides \ifnumgreater{<int expr.>}{<int expr.>}{<true>}{<false>},
% \apptocmd{<command>}{<code>}{<success>}{<failure>} and \newtoggle{<name>}
\RequirePackage{etoolbox}

% enable simple math like +/- etc. on lengths
\RequirePackage{calc}

% change page margins
\RequirePackage[
	nohead,
	nofoot,
	nomarginpar,
]{geometry}

% provides basic conditional expressions
\RequirePackage{ifthen}

% pre-define some colors the user can choose from
\definecolor{cvblue}{HTML}{0E5484}
\definecolor{cvgreen}{HTML}{007170}
\definecolor{cvred}{HTML}{8B0000}

\definecolor{cvsidecolor}{HTML}{E7E7E7}
\definecolor{cvsectioncolor}{HTML}{0395DE}
\definecolor{cvsubsectioncolor}{HTML}{4D4D4D}

% set default color values
\colorlet{background}{white}                    % document background color
\colorlet{maincolor}{cvblue}                    % main color for section text, icons and skills
\colorlet{sidecolor}{cvsidecolor}               % background color in sidebar
\colorlet{sidetext}{black!90}                   % text color in sidebar
\colorlet{sectioncolor}{cvsectioncolor}         % section text color in main body
\colorlet{subsectioncolor}{cvsubsectioncolor}   % subsection text color in main body
\colorlet{itemtextcolor}{black}                 % normal text color in main body
\colorlet{pseccolor}{maincolor!90}              % section text color in sidebar
\colorlet{jobcolor}{cvsubsectioncolor}          % job text color in sidebar
\colorlet{iconcolor}{subsectioncolor}                 % icon color
\colorlet{iconbodycolor}{pseccolor}             % icon body color
\colorlet{wheelchartlabelcolor}{black}          % label text color in wheelchart
\colorlet{wheeltextcolor}{black!80!white}       % text color in wheelchart
\colorlet{skillbg}{black!25}                    % background color in skills symbols
\colorlet{skilltop}{iconcolor!70}               % color in skills symbols

\newcommand{\setfont}{}
\newboolean{inversecolors}
\setboolean{inversecolors}{false}
\newboolean{bgcolor}
\setboolean{bgcolor}{false}
\newboolean{seccolor}
\setboolean{seccolor}{false}
\newboolean{subseccolor}
\setboolean{subseccolor}{false}
\newboolean{textcolor}
\setboolean{textcolor}{false}
\newboolean{iconcolor}
\setboolean{iconcolor}{false}

% let user define main color
\DeclareOptionX{mainfont}{\renewcommand{\setfont}{\setmainfont{#1}}}
\DeclareOptionX{background}{\colorlet{background}{#1}\setboolean{bgcolor}{true}}
\DeclareOptionX{maincolor}{\colorlet{maincolor}{#1}\colorlet{sidecolor}{#1!20}\colorlet{sectioncolor}{#1!90}\colorlet{pseccolor}{#1!90}\colorlet{subsectioncolor}{#1!60!itemtextcolor}\colorlet{iconcolor}{#1!90}\colorlet{iconbodycolor}{#1!90}\colorlet{skillbg}{#1!10}\colorlet{skilltop}{#1!63}}
\DeclareOptionX{sidecolor}{\colorlet{sidecolor}{#1}}
\DeclareOptionX{sidetext}{\colorlet{sidetext}{#1}}
\DeclareOptionX{sectioncolor}{\colorlet{sectioncolor}{#1}\colorlet{subsectioncolor}{#1!70!itemtextcolor}\colorlet{iconbodycolor}{#1}\setboolean{seccolor}{true}}
\DeclareOptionX{subsectioncolor}{\colorlet{subsectioncolor}{#1}\setboolean{subseccolor}{true}}
\DeclareOptionX{itemtextcolor}{\colorlet{itemtextcolor}{#1}\colorlet{subsectioncolor}{maincolor!60!#1}\setboolean{textcolor}{true}}
\DeclareOptionX{pseccolor}{\colorlet{pseccolor}{#1}}
\DeclareOptionX{jobcolor}{\colorlet{jobcolor}{#1}}
\DeclareOptionX{iconcolor}{\colorlet{iconcolor}{#1}\colorlet{skilltop}{#1!70}}
\DeclareOptionX{iconbodycolor}{\colorlet{iconbodycolor}{#1}\setboolean{iconcolor}{true}}
\DeclareOptionX{wheelchartlabelcolor}{\colorlet{wheelchartlabelcolor}{#1}}
\DeclareOptionX{wheeltextcolor}{\colorlet{wheeltextcolor}{#1}}
\DeclareOptionX{skillbg}{\colorlet{skillbg}{#1}}
\DeclareOptionX{skilltop}{\colorlet{skilltop}{#1}}
\DeclareOptionX{inversecolors}{\setboolean{inversecolors}{true}}

%	set page margins
\newlength\sidebarwidth%
\newlength\topbottommargin%
\newlength\leftrightmargin%
\newlength\sidebartextwidth
% default values
\setlength{\sidebarwidth}{0.34\paperwidth}
\setlength{\topbottommargin}{0.02\paperheight}
\setlength{\leftrightmargin}{0.02\paperwidth}
% user overwrites
\DeclareOptionX{sidebarwidth}{\setlength{\sidebarwidth}{#1}}
\DeclareOptionX{topbottommargin}{\setlength{\topbottommargin}{#1}}
\DeclareOptionX{leftrightmargin}{\setlength{\leftrightmargin}{#1}}

% profile picture settings
\newlength\profilepicsize%
\setlength{\profilepicsize}{0.7\sidebarwidth}
\newcommand{\profileshape}{\profileround}
\DeclareOptionX{profilepicsize}{\setlength{\profilepicsize}{#1}}
\DeclareOptionX{profileshape}{\ifstrequal{#1}{round}{\renewcommand{\profileshape}{\profileround}}{\ifstrequal{#1}{roundedcorners}{\renewcommand{\profileshape}{\profileroundedcorners}}{}}}

% show sidebar and page margins
\newtoggle{tshowframes}
\togglefalse{tshowframes}
\DeclareOptionX{showframes}{
  \geometry{showframe}
  \TPoptions{showboxes=true}
  \toggletrue{tshowframes}
  % adding \hline in \newenvironment directly doesn't work, so do it here...
	\AtBeginDocument{\apptocmd{\personaldata}{\hline}{}{}}
}

% draw vertical guideline
\newcommand{\plotvline}{}
\DeclareOptionX{vline}{%
	% must be defined here as macro, b/c tikz won't expand absolute length in
	% \backgroundsetup -- BUG?
	\renewcommand{\plotvline}{%
		\draw [thick, red, opacity=0.7] 
		(\leftrightmargin + #1, 0) -- (\leftrightmargin + #1, -\paperheight);
	}
}

% pass further options to base class and load it
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptionsX\relax
\LoadClass{article}

% compute "inner" margin of sidebar automatically;
% must come after \sidebarwidth and \leftrightmargin possibly changed by user
\setlength{\sidebartextwidth}{\sidebarwidth - 2\leftrightmargin}

% let geometry package perform the changes;
% must come after loading the base class to prevent overwriting
\geometry{
	top=\topbottommargin,
%	bottom=\topbottommargin,
	bottom=0ex,
	left=\sidebarwidth + \leftrightmargin,
	right=\leftrightmargin,
}

%-------------------------------------------------------------------------------
%                              REQUIRED PACKAGES
%-------------------------------------------------------------------------------
% font configuration
\ifdefempty{\setfont}{\RequirePackage[sfdefault]{ClearSans}}{}

% use as workaround for spacing problem when TikZ picture is not in paragraph;
% details: https://tex.stackexchange.com/a/435790
\RequirePackage{background}

% for easy section style definitions
\RequirePackage{titlesec}

% loads graphicx, provides align=c option for vertical alignment w.r.t. text
\RequirePackage{graphbox} 

% provides X column type for automatic length calculations
\RequirePackage{tabularx}

% take care of compiler-specific packages
\RequirePackage{ifluatex}
\RequirePackage{ifxetex}
\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

% pictures, icons and drawings
\ifxetexorluatex
	\RequirePackage{fontawesome}
	\RequirePackage{academicons}
\else
	\RequirePackage{fontawesome}
\fi
\RequirePackage{fontmfizz}
\RequirePackage{tikz}
\usetikzlibrary{arrows, backgrounds}

% provides \xrfill for horizontal rules
\RequirePackage{xhfill}

% enable multiple optional arguments in macros
\RequirePackage{xparse}

% enable links
\RequirePackage[hidelinks]{hyperref}


% improve word spacing and hyphenation
\ifxetexorluatex
\else
    \RequirePackage{microtype}
\fi    
\RequirePackage{ragged2e}

% take care of proper font encoding
\ifxetexorluatex
	\RequirePackage{fontspec}
	\defaultfontfeatures{Ligatures=TeX}
    %\newfontfamily\headingfont[Path = fonts/]{segoeuib.ttf} % local font
    \RequirePackage{fontmfizz}
    \RequirePackage{typicons}
\else
	\RequirePackage{}package[utf8]{inputenc}
	\RequirePackage{}package[T1]{fontenc}
    %\usepackage[sfdefault]{noto} % use noto google font
\fi

% enable mathematical syntax for some symbols like \varnothing
\RequirePackage{amssymb}

% bubble diagram configuration
\RequirePackage{smartdiagram}
\smartdiagramset{
  % defaut font size is \large, so adjust to harmonize with sidebar layout
  bubble center node font = \footnotesize,
  bubble node font = \footnotesize,
  % default: 4cm/2.5cm; make minimum diameter relative to sidebar size
  bubble center node size = 0.4\sidebartextwidth,
  bubble node size = 0.25\sidebartextwidth,
  distance center/other bubbles = 1.5em,
  % set center bubble color
  bubble center node color = maincolor!70,
  % define the list of colors usable in the diagram
  set color list = {maincolor!10, maincolor!40,
  maincolor!20, maincolor!60, maincolor!35},
  % sets the opacity at which the bubbles are shown
  bubble fill opacity = 0.8,
}

% For custom icons. From .svg to .tex with Inkscape
\RequirePackage{pstricks}



%-------------------------------------------------------------------------------
%                      GLOBAL LAYOUT AND HEADINGS STYLE
%-------------------------------------------------------------------------------
% remove headers and footers
\pagestyle{empty}

% globally disable paragraph indentation
\setlength{\parindent}{0pt}

% set space between paragraphs
% \setlength{\parskip}{1ex}

% creates a rule after some text using remaining line width
% usage: \xrfill[<raise>]{<width>}
\newcommand*{\sectionline}[1]{#1~\xrfill[.5ex]{1pt}[pseccolor]} 

% section style for cv table headings in right column
% \titleformat{<command>}[<shape>]{<format>}{<label>}{<sep>}{<before>}[<after>]
\newcommand*{\cvsection}[1]{\section*{#1}}
\titleformat{\section}%
	{\color{sectioncolor}\normalfont\bfseries\LARGE}{}{0pt}{}
\titlespacing*{\section}{0pt}{1ex}{0.5ex}

% grey subsection style for right column
\newcommand*{\cvsubsection}[1]{\subsection*{#1}}
\titleformat{\subsection}%
	{\color{subsectioncolor}\normalfont\large}{}{0pt}{}
% set spaces before and after subsections: <left><before><after>
\titlespacing*{\subsection}{0pt}{0ex}{-0.5ex}
	
% abuse subsubsection as profilesection in left column
\newcommand*{\profilesection}[1]{\subsubsection*{#1}}
\titleformat{\subsubsection}
	{\color{pseccolor}\normalfont\huge}{}{0pt}{\color{pseccolor}\sectionline}
% set spaces before and after profilesections: <left><before><after>
% "starred version kills the indentation of the paragraph following the title"
\titlespacing*{\subsubsection}{0pt}{1ex}{-1ex}

% set color for the global document
\newcommand{\setcolor}{
    \ifthenelse{\boolean{inversecolors}}{
        \ifthenelse{\boolean{bgcolor}}{}{\colorlet{background}{maincolor}}
        \ifthenelse{\boolean{seccolor}}{}{\colorlet{sectioncolor}{maincolor!40}}
        \ifthenelse{\boolean{subseccolor}}{}{\colorlet{subsectioncolor}{maincolor!30}}
        \ifthenelse{\boolean{textcolor}}{}{\colorlet{itemtextcolor}{maincolor!10}}
        \ifthenelse{\boolean{iconcolor}}{}{\colorlet{iconbodycolor}{maincolor!40}}
        \pagecolor{background}
    }{
        \pagecolor{background}
    }
}


%-------------------------------------------------------------------------------
%                              SIDEBAR ELEMENTS
%-------------------------------------------------------------------------------
% mandatory personal information
\newcommand*{\cvname}[1]{\renewcommand{\cvname}{#1}}
\newcommand*{\cvjobtitle}[1]{\renewcommand{\cvjobtitle}{#1}}

% profile picture (optional)
\newcommand{\plotprofilepicture}{}
\newcommand*{\cvprofilepic}[1]{
	\renewcommand{\cvprofilepic}{#1}
	\renewcommand{\plotprofilepicture}{\profileshape}
}

% social network item; \social{<icon>}{<url>}{<text>}
\newcommand*{\social}[3]{%
	\socialicon{#1} & \href{#2}{#3}\\%
}

% personal information item; \personal{<icon>}{<text>}
\newcommand*{\personal}[2]{%
	\circleicon{#1} & {\textcolor{sidetext}{#2}}\\%
}

% other personal information as macro that can be used later. Usage:
% \cvcustomdata{<Icon>}{<Text>}
% icon can be taken from FontAwesome or Academicon for example
\newcommand{\personaldata}{}
\newcommand*{\cvcustomdata}[2]{%
	\apptocmd{\personaldata}{\personal{#1}{#2}}{}{}%
}

% useful shortcuts
% NOTE: we use href instead of url so user can decide textformatting since url
% automatically uses \texttt{} as format for the url
\newcommand*{\cvbirthday}[1]{\cvcustomdata{\faUser}{#1}}
\newcommand*{\cvaddress}[1]{\cvcustomdata{\faEnvelope}{#1}}
\newcommand*{\cvphone}[1]{\cvcustomdata{\faPhone}{#1}}
\newcommand*{\cvsite}[1]{\cvcustomdata{\faGlobe}{\href{#1}{#1}}}
\newcommand*{\cvmail}[1]{\cvcustomdata{\faAt}{\href{mailto:#1}{#1}}}
\newcommand*{\cvkey}[2]{\cvcustomdata{\faKey}{%
	\href{https://keyserver.ubuntu.com/pks/lookup?search=#2\&op=vindex\&fingerprint=on}{#1}%
}}

% TODO find a cleaner solution for consistent spacing
\newcommand{\nameandjob}{%
	{\Huge\color{maincolor}\cvname}\par%
	\setlength{\parskip}{2ex}
	{\Large\color{jobcolor}\cvjobtitle}\par%
	\setlength{\parskip}{1ex}
}

\newcommand{\profileroundedcorners}{%
	\begin{figure}\centering
		% see TikZ/pgf v3.1.1 manual §2.11 (clipping), §14.5 (rounded corners),
		% §12 (scopes), §13.2 (coordinate systems)
		\begin{tikzpicture}[x=\profilepicsize, y=\profilepicsize]
			\begin{scope}
			\path[clip]
				(0, 0) [sharp corners] -- 
				(0, 1) [rounded corners=0.15\sidebartextwidth] -- 
				(1, 1) [sharp corners] --
				(1, 0) [rounded corners=0.15\sidebartextwidth] -- cycle;
			\node[anchor=south west, inner sep=0pt] (profilepic) at (0, 0)
				{\includegraphics[width=\profilepicsize]{\cvprofilepic}};
			\end{scope}
			\begin{scope}
			\draw	[line width=0.02\sidebartextwidth, color=iconcolor]
				(0, 0) [sharp corners] -- 
				(0, 1) [rounded corners=0.15\sidebartextwidth] -- 
				(1, 1) [sharp corners] --
				(1, 0) [rounded corners=0.15\sidebartextwidth] -- cycle;
			\end{scope}
		\end{tikzpicture}
	\end{figure}
}

\newcommand{\profileround}{%
	\begin{figure}\centering
		% see TikZ/pgf v3.1.1 manual §2.11 (clipping), §14.5 (rounded corners),
		% §12 (scopes), §13.2 (coordinate systems)
		\begin{tikzpicture}[x=\profilepicsize, y=\profilepicsize]
			%\begin{scope}
			    \clip (0.5, 0.5) circle (\profilepicsize/2);
			    \node[anchor=south west, inner sep=0pt] (profilepic) at (0, 0)
				    {\includegraphics[width=\profilepicsize]{\cvprofilepic}};
			%\end{scope}
		\end{tikzpicture}
	\end{figure}
}

% table with 2 columns for icons and text
% \icontable{<width 1st column>}{<space between columns>}{<arraystretch>}
\newenvironment{icontable}[3][1]%
{%
	\renewcommand{\arraystretch}{#1}% increase linespacing in tables; default=1
	\iftoggle{tshowframes}{%
		% https://tex.stackexchange.com/a/42331
		\tabularx{\sidebartextwidth}{|m{#2} | @{\hskip #3} | X|} \hline%
	}{%
		\tabularx{\sidebartextwidth}{m{#2} @{\hskip #3} X}%
	}
}{%
	\endtabularx%
}

% icon style for personal information
\newcommand*\circleicon[1]{%
	\tikz[baseline = (char.base)]{%
		\node[%
			shape=circle,%
			draw,%
			inner sep=1pt,%
			fill=iconcolor,%
			iconcolor,%
			text=white,%
			minimum size=\hsize%
		] (char) {#1};%
	}%
}

% icon style for social network
\newcommand*{\socialicon}[1]{%
	\resizebox{\hsize}{!}{\textcolor{iconcolor}{#1}}%
}


% make sure about me text stays in textbox frame
\newcommand{\aboutme}[1]{\parbox[b]{\linewidth}{#1}}

% uniform icon style for all skill icons, e.g. flags or fontawesome icons
\newcommand{\cvicon}[1]{\makebox[1em]{\color{iconcolor} #1}}
\newcommand{\bodyicon}[1]{\makebox[1em]{\color{iconbodycolor} #1}}
\newcommand{\flag}[1]{\includegraphics[align=c, width=1em]{pics/flags/#1.png}}
\newcommand{\customicon}[1]{
    \begin{tikzpicture}
        \begin{scope}[blend group=lighten];
            \begin{scope}[blend group=difference]
                \node[inner sep=0,line width=0] (icon) {\includegraphics[align=c, width=1em]{pics/icons/#1}};
                \fill[black] (icon.south west) rectangle (icon.north east);
            \end{scope}
            \fill[iconcolor] (icon.south west) rectangle (icon.north east);
        \end{scope}
    \end{tikzpicture}
}
% Change color and dimensions in .tex file
% scale = 2/[max_lenght in <\begin{pspicture}(x,y)>]
% color = iconcolor (<\pscustom[linestyle=none,fillstyle=solid,fillcolor=iconcolor]>)
\newcommand{\cvtexicon}[1]{\input{pics/icons/#1.tex}}

% \pointskill[<indent>]{<icon>}{<description>}{<points>}[<maxpoints>] creates 
% | [indent] [icon]  description  \hfill  ● ● ● ○ ○ | 
% -- inspired by arravc.cls by LianTze Lim: https://github.com/liantze/AltaCV
\NewDocumentCommand{\pointskill}{ O{0em} m m m O{5} }{%
	\hspace{#1} \cvicon{#2} ~ #3 \hfill%
	\foreach \x in {1,...,#5}{%
		\space%
		{\ifnumgreater{\x}{#4}{\color{skillbg}}{\color{skilltop}}% from etoolbox
		% don't use totalheight; see https://tex.stackexchange.com/a/41014
		\raisebox{0.5\height-0.4ex}{\scriptsize\faCircle}%
		}
	}\par%
}

\newcommand{\barskill}[3]{ 
	% remove 1pt in width to prevent overfull box warnings
	\begin{tikzpicture}[x=\sidebartextwidth-1pt, y=2ex]
			\draw[fill, skillbg, rounded corners=0.5em] 
				(0, 0) rectangle (1, 1);
			\draw[fill, skilltop, rounded corners=0.5em] 
				(0, 0) rectangle (#3/100, 1);
			\node[above right] at (0, 1) {\cvicon{#1} ~ #2};
	\end{tikzpicture}
	\par
}

% \skill[<indent>]{<icon>}{<description>} creates in sidebar
% | [indent] [icon]  some longer skill description  |
\newcommand{\skill}[3][0em]{
	\hspace{#1} \cvicon{#2} ~ \parbox{\linewidth-#1-2.5em}{#3} \hfill \par
}

% label for wheel charts
\newcommand{\chartlabel}[1]{%
	\begin{tikzpicture}
  	\node[
	  	fill=skillbg!25, % interior color
	  	anchor=base,
	  	draw=skillbg, % line color
	  	rounded corners,
	  	inner xsep=1ex, % distance from left/right border to text
	  	inner ysep=0.75ex, % distance top/bottom border to text
	  	text height=1.5ex, % align text vertically in box (at least as resulting
	  	text depth=.25ex   % effect)
  	]{#1};%
	\end{tikzpicture}
}


\newenvironment{memberships}[1][1em]%
{%
	\iftoggle{tshowframes}{%
		\tabularx{\sidebartextwidth}{|l | @{\hskip #1} | X|} \hline%
	}{%
		\tabularx{\sidebartextwidth}{l @{\hskip #1} X}%
	}
}{%
	\endtabularx%
}


\newcommand{\membership}[3][4em]{
	\includegraphics[align=c,width=#1]{#2} & {#3} \\[3ex]
}

% adapted from https://tex.stackexchange.com/a/82729
\newcommand{\wheelchart}[4][-90]{%
    \def\outerradius{#2}%
    \def\innerradius{#3}%
    % Calculate total
    \pgfmathsetmacro{\totalnum}{0}%
    \foreach\value/\colour/\name in {#4} {%
        \pgfmathparse{\value+\totalnum}%
        \global\let\totalnum=\pgfmathresult%
    }%
    \begin{tikzpicture}

      % Calculate the thickness and the middle line of the wheel
      \pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
      \pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}

      % Rotate so we start from the top
      \begin{scope}[rotate=#1, on background layer]
      % Loop through each value set. \cumnum keeps track of where we are in the
      % wheel                
      \pgfmathsetmacro{\cumnum}{0}
      \foreach \value/\width/\colour/\name in {#4} {
            \pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

            % Calculate the percent value
            \pgfmathsetmacro{\percentage}{\value/\totalnum*100}
            % Calculate the mid angle of the colour segments to place the labels
            \pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

            % This is necessary for the labels to align nicely
            \pgfmathparse{
               (-\midangle>180?"west":"east")
            } \edef\textanchor{\pgfmathresult}
            \pgfmathparse{
               (-\midangle>180?"flush left":"flush right")
            } \edef\textalign{\pgfmathresult}
            \pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

            % Draw the color segments. Somehow, the \midrow units got lost, so
            % we add 'pt' at the end. Not nice...
            \filldraw[draw=white,fill=\colour] 
	            (-\cumnum:\outerradius) 
	            arc (-\cumnum:-(\newcumnum):\outerradius) 
	            -- (-\newcumnum:\innerradius) 
	            arc (-\newcumnum:-(\cumnum):\innerradius) 
	            -- cycle;

            % Draw the data labels
            \draw [*-,thin,wheelchartlabelcolor] node [append after command={
		          (\midangle:\midradius pt) -- 
 	  	        (\midangle:\outerradius + 1ex) -- 
		          (\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [
		          xshift=\labelshiftdir*0.5cm,inner sep=1ex, 
		          outer sep=0pt, 
		          text width=\width,
		          anchor=\textanchor,
		          align=\textalign,
		          font=\small,
		          text=wheeltextcolor
	          ]{\name};
            % Set the old cumulated angle to the new value
            \global\let\cumnum=\newcumnum
        }
      \end{scope}
    \end{tikzpicture}\par
}

\newcommand{\cvsignature}{
	\vfill
	{\large\bfseries\color{maincolor!70}\today \hfill \cvname}
}


%-------------------------------------------------------------------------------
%                               SIDEBAR LAYOUT
%-------------------------------------------------------------------------------
% draw sidebar background on every page
\backgroundsetup{
	opacity=1, 
	scale=1, 
	angle=0, 
	position=current page.north west,
	contents={%
		\begin{tikzpicture}[remember picture, overlay]
   		\node[
   			rectangle,
   			fill=sidecolor,
   			anchor=north west,
   			minimum width=\sidebarwidth,
   			minimum height=\paperheight,
			]{};% (frontsidebar) at (current page.north west){};
			% plot vertical red guideline
			\plotvline
		\end{tikzpicture}
	}
}

% use textpos to position textblock within TikZ background; we have to use
% the starred version for absolute values here, b/c we use \pagewidth directly
% instead of \setlength{\TPHorizModule}{<dimen>}, which seems to be "absolute" 
% as opposed to "relative" - strange but true.
\newenvironment{sidebar}%
	{\begin{textblock*}{\sidebartextwidth}(\leftrightmargin, \topbottommargin)}%
	{\end{textblock*}}

% provide user interface for easily adding new sections in side bars
% default: empty sidebar
\newcommand{\frontsidebar}{}
\newcommand{\backsidebar}{}
\newcommand{\addtofrontsidebar}[1]{\apptocmd{\frontsidebar}{#1}{}{}}
\newcommand{\addtobacksidebar}[1]{\apptocmd{\backsidebar}{#1}{}{}}

\newcommand{\makefrontsidebar}{%
	\begin{sidebar}
		% most sidebar commands end with \par; increase space between them
		\setlength{\parskip}{1ex}

		% insert profile picture
		\plotprofilepicture
		\vspace{1ex}

		% name and job
		\nameandjob

		% personal information
		\vspace*{0.5em}
		\begin{icontable}[1.6]{1.7em}{0.4em}
			\personaldata
		\end{icontable}

		% user definitions
		\frontsidebar
	\end{sidebar}
}

\newcommand{\makebacksidebar}{%
    \newpage
 	\begin{sidebar}
		% begin with name instead of picture
		\nameandjob
		
		% make sure there is no space at top, but after cvjob
		\setlength{\parskip}{1ex}

		% user definitions
		\backsidebar
	\end{sidebar}
}


%-------------------------------------------------------------------------------
%                              LIST ENVIRONMENTS
%-------------------------------------------------------------------------------
% reduce space between table columns to minimum
\setlength{\tabcolsep}{0pt}

% cv list environment --> table, left aligned, width=textwidth
% tabular starred version adds space to make table as wide as \textwidth here
\newenvironment{cvtable}[1][2]{%
	\renewcommand{\arraystretch}{#1}%
	\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}ll}%
}{%
	\end{tabular*}
}

% | <keyword>      <one-line description>            |
% use parbox if text needs to use multiple lines
\newcommand{\cvitemshort}[2]{%
	\parbox[t]{0.17\textwidth}{\hfill\textcolor{itemtextcolor}{#1}}
  & \parbox[t]{0.81\textwidth}{\textcolor{itemtextcolor!90}{#2}} \\}

% | <date>         <bold-title>  \hfill  <location>  |
% |                <longer description>              |
% or, if description is empty:
% | <date>         <title>       \hfill  <location>  |
\newcommand{\cvitem}[4]{%
	\parbox[t]{0.17\textwidth}{\textcolor{itemtextcolor}{#1}} &%
	\parbox[t]{0.81\textwidth}{%
		\if\relax\detokenize{#4}\relax%
			\parbox[t]{\linewidth-\widthof{\footnotesize #3}-1em}{%
			    \textcolor{itemtextcolor}{\textbf{\RaggedRight#2}}}%
  		\hfill {\textcolor{itemtextcolor}{\footnotesize#3}}%
		\else%
			\parbox{\linewidth-\widthof{\footnotesize#3}-1em}{%
				\textcolor{itemtextcolor}{\textbf{\RaggedRight#2}}%
			} \hfill {\textcolor{itemtextcolor}{\footnotesize#3}} \\% 
			\textcolor{itemtextcolor!90}{#4}%\vspace{\parsep}%
		\fi%
	}\\
}

% publication item
% \cvpubitem{<title>}{<author>}{<journal>}{<year>} will produce 
% | <year>         <bold title>                      |
% |                <italic author>                   |
% |                <journal>                         |
\newcommand{\cvpubitem}[4]{%
	\parbox[t]{0.17\textwidth}{\raggedright #4} &
	\parbox[t]{0.81\textwidth}{%
		\textbf{#1} \par \textit{#2} \par #3 \vspace{\parsep}%
	}\\
}

% EOF - EightySecondsCV.cls
