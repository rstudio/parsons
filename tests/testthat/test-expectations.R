context("expectations")

test_that("pass_if works", {

  expect_is(
    pass_if("x"),
    "tutorial_question_answer"
  )

  expect_is(
    pass_if(~x == 1, "1"),
    "parsons_expectation_pass"
  )

  expect_is(
    pass_if(function(x)x == 1, "1"),
    "parsons_expectation_pass"
  )

})

test_that("fail_if works", {

  expect_is(
    fail_if("x"),
    "tutorial_question_answer"
  )

  expect_is(
    fail_if(~x == 1, "1"),
    "parsons_expectation_fail"
  )

  expect_is(
    fail_if(function(x)x == 1, "1"),
    "parsons_expectation_fail"
  )

  expect_is(
    fail_if(function(x){!"print()" %in% x}, "1"),
    "parsons_expectation_fail"
  )

})
