.SUFFIXES: .erl .beam .yrl

.erl.beam:
	erlc -W $<

ERL = erl -boot start_clean -noshell

all: compile

MODS = wp

compile: ${MODS:%=%.beam}

.PHONY: test clean
test_light: compile
	time ${ERL} -s wp wp wp.erl -s init stop >test_light_output.txt
test_heavy: compile
	time ${ERL} -s wp wp testfile -s init stop >test_heavy_output.txt

clean:
	rm -rf *.beam erl_crash.dump test_*_output.txt *.trace