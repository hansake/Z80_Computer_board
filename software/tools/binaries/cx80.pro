#	STANDARD ANSI C ENVIRONMENT PROTOTYPE FILE
#	FOR LINUX Cross to 64180/z80
#	Programmable flag options:
#
#	64180	: generate code for 64180 instead of Z80
#	dl1	: generate line info dl1 style
#	dl2	: generate line info dl2 style
#	far	: far calls on Z80
#	float	: add floating point libraries at link time
#	lincl	: include header files in listing or diagnostic output
#	listc	: create C source listing with interspersed error messages
#	listcs	: create c/assembler listing
#	map	: create a map file (r).map
#	nobss	: do not use the bss section
#	noopt	: do not do optimize assembler code
#	nostrict: allow more lenient type checking
#	prom	: move rom to ram on startup
#	proto	: enable prototype checking
#	rev	: reorder bits inbitfields from most to least significant
#	savlnk	: save the linker file
#	schar	: make "plain" char signed char (default is unsigned)
#	sp	: enable single precision with double precision
#	std	: force the output to conform to ANSI C draft standard
#	strict	: enforce more stronger tye checking
#	sprec	: generate code for single-precision floating point
#		  double are converted to float
#	verbose	: display name of C functions as they are processed by the
#		  code generator
#	xdebug	: generate debugging info for cxdb

c:(e)cpp80	-o (o) -x {lincl?+lincl} {proto?-d_PROTO} \
		{std?+std} {listc?-err} \
		{listcs?-err} -i (h) \
		{dl1?+lincl:{dl2?+lincl}} {xdebug?+xdebug} \
		(i)

1:(e)cp180	-o (o) -sr -m {schar?:-u} {std?+std}  \
		{listcs?-err} {listc? -err > (r).err} \
	 	{nostrict?-strict} {strict?+strict} \
		{xdebug?+xdebug} {dl1?-dl:{dl2?-dl}} \
		{sprec?-sp} \
		(i)
 {listc?echo \"\#error cp1(V3.32) (r).c\:0\" >> (r).err}
 {listc?(e)lm -o (r).tmp -err -lt (r).err}
 {listc?(e)prw -err -t (r).c (r).tmp > (r).lst}
 {listc?mv (r).err (r).tmp}

2:(e)cp280	-o (o) -x6 {64180?-h64180} {far?-far} \
		{nobss? -bss} {listcs?+list -err} \
		{dl1?-dl1:{dl2?-dl2}} \
		{rev?-rev} {sp?-sp} \
		{verbose?-v} \
		(i)

3:(e)cp380	-o (o) {noopt?-z} -e -r30 (i)
 {listcs?(e)lm -o (r).tmp -err -lt -c \";\" (o)}
 {listcs?mv (r).tmp (o) }

s:(e)x80	-o (o) {listcs?+l >(r).ls} (i)

o::echo		 -o (o) {prom?+h} > (r).lnk
 echo		{map?+map=(r).map} \
		+text -b0x0000 \
		+data -b0x8000 \
 		Crts{prom?rom}.o (i) >> (r).lnk
 echo		{float?(l)lib{sprec?f:d}.{64180?1:z}80} \
		(l)libi.{64180?1:z}80 \
 		(l)libm.{64180?1:z}80 >> (r).lnk
 echo		+def __romdata=__text__ +def __memory=__bss__  >> (r).lnk
 (e)lnk80 < (r).lnk
 {prom?(e)toprom -o (r).prm (r).80}
 {prom?mv (r).prm (r).80}
 {savlnk?:rm	(r).lnk}
80:

