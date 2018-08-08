all: go_generics go_merge test

clean:
	@rm -f go_generics
	@rm -f go_generics_tests.tgz
	@rm -f go_generics_test_bundle
	@rm -f go_merge

go_generics:
	@go build -a -ldflags "-extldflags '-static'" -o $@ ./cmd/go_generics

go_merge:
	@go build -a -ldflags "-extldflags '-static'" -o $@ ./cmd/go_merge

go_generics_tests.tgz: go_generics
	@tar -czvhf $@ go_generics generics_tests

go_generics_test_bundle: go_generics_tests.tgz go_generics_unittest.sh
	@cat go_generics_unittest.sh go_generics_tests.tgz > $@
	@chmod u+x $@

test: go_generics_test_bundle
	./go_generics_test_bundle
