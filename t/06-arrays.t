use v6.c;
use Test;
use Trait::Env;

class TestClass {
    has @.simple-array is env(:default([1,2]));
}

class RequiredTest {
    has @.required-array is env(:required);
}

class TypeTest {
    has Bool @.bool is env;
    has Int  @.int  is env;
    has      @.arr  is env;
}

class SepTest {
    has @.list is env(:sep<:>);
}

subtest {
    temp %*ENV = (
        :SIMPLE_ARRAY_1<1>,
        :SIMPLE_ARRAY_2<2>,
        :SIMPLE_ARRAY_3<3>,
        :SIMPLE_ARRAY_4<4>
    );

    my $tc = TestClass.new();
    is $tc.simple-array, ["1","2","3","4"], "Simple Array Works";

}, "Simple Numeric Array";

subtest {
    temp %*ENV = (
        :SIMPLE_ARRAY_A<1>,
        :SIMPLE_ARRAY_B<2>,
        :SIMPLE_ARRAY_C<3>,
        :SIMPLE_ARRAY_D<4>
    );

    my $tc = TestClass.new();
    is $tc.simple-array, ["1","2","3","4"], "Simple Array Works";

}, "Lexical Ordering";


subtest {
    temp %*ENV = (
        :SIMPLE_ARRAY1<4>,
        :SIMPLE_ARRAY2<3>,
        :SIMPLE_ARRAY3<2>,
        :SIMPLE_ARRAY4<1>
    );

    my $tc = TestClass.new();
    is $tc.simple-array, ["4","3","2","1"], "Ordering on keys works";

}, "Check Ordering";

subtest {
    temp %*ENV = ();

    my $tc = TestClass.new();
    is $tc.simple-array, [1,2], "Default OK";

}, "Check Default";

subtest {
    temp %*ENV = ();

    throws-like { my $tc = RequiredTest.new() }, X::Trait::Env::Required::Not::Set, "Test Class dies with missing required";

}, "Required test";

subtest {
    temp %*ENV = ();

    my $tc = TypeTest.new();
    ok $tc.bool ~~ Array[Bool], "We have any empty type";
    ok $tc.int ~~ Array[Int], "We have any empty type";
    ok $tc.arr ~~ Array, "Empty Array";

}, "Empty Typed";

subtest {
    temp %*ENV = ( :INTA<1>, :INTB<2>, :INTC<3> );

    my $tc = TypeTest.new();
    is-deeply $tc.int, Array[Int].new(1,2,3), "We have an array";

}, "Int Typed";

subtest {
    temp %*ENV = ( :BOOL_A<True>, :BOOL_B<False>, :BOOL_C<1>, :BOOL_D('') );

    my $tc = TypeTest.new();
    is-deeply $tc.bool, Array[Bool].new(True,False,True,False), "We have an array";

}, "Bool Typed";

subtest {
    temp %*ENV = ( :LIST<1:2:3:4:5> );

    my $tc = SepTest.new();
    is $tc.list, <1 2 3 4 5>, "We have a seperated list";
}


done-testing;
