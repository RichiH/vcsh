load environment

@test "Debug output includes git version" {
	"$VCSH" -d init foo |& grep -q 'git version [0-9]'
	"$VCSH" -d list |& grep -q 'git version [0-9]'
	# XXX add more?
}
