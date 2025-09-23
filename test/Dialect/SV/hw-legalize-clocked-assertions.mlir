// RUN: circt-opt -hw-legalize-modules -verify-diagnostics %s | FileCheck %s

module attributes {circt.loweringOptions = "disallowClockedAssertions"} {

hw.module @clocked_assert(in %clock : i1, in %prop : i1) {
  sv.assert_property %prop on posedge %clock : i1
}

// CHECK:      hw.module @clocked_assert(in %clock : i1, in %prop : i1) {
// CHECK-NEXT:   sv.always posedge %clock {
// CHECK-NEXT:     sv.assert_property %prop : i1
// CHECK-NEXT:   }

hw.module @clocked_assume(in %clock : i1, in %prop : i1) {
  sv.assume_property %prop on posedge %clock : i1
}

// CHECK:      hw.module @clocked_assume(in %clock : i1, in %prop : i1) {
// CHECK-NEXT:   sv.always posedge %clock {
// CHECK-NEXT:     sv.assume_property %prop : i1
// CHECK-NEXT:   }

hw.module @clocked_cover(in %clock : i1, in %prop : i1) {
  sv.cover_property %prop on posedge %clock : i1
}

// CHECK:      hw.module @clocked_cover(in %clock : i1, in %prop : i1) {
// CHECK-NEXT:   sv.always posedge %clock {
// CHECK-NEXT:     sv.cover_property %prop : i1
// CHECK-NEXT:   }

hw.module @assert_disable_iff(in %prop : i1, in %disable : i1) {
  sv.assert_property %prop disable_iff %disable : i1
}

// CHECK:      hw.module @assert_disable_iff(in %prop : i1, in %disable : i1) {
// CHECK-NEXT:   %0 = comb.or %prop, %disable : i1
// CHECK-NEXT:   sv.assert_property %0 : i1

hw.module @assert_clocked_disable_iff(in %clock : i1, in %prop : i1, in %disable : i1) {
  sv.assert_property %prop on posedge %clock disable_iff %disable : i1
}

// CHECK:      hw.module @assert_clocked_disable_iff(in %clock : i1, in %prop : i1, in %disable : i1) {
// CHECK-NEXT:   %0 = comb.or %prop, %disable : i1
// CHECK-NEXT:   sv.always posedge %clock {
// CHECK-NEXT:     sv.assert_property %0 : i1
// CHECK-NEXT:   }

} // end builtin.module
