use src::new_module::add::add_two_nummbers;

#[test]
fn test_add() {
    let x = add_two_nummbers(5, 6);
    assert(x == 11, 'Error');
}