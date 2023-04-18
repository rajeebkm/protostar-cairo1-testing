use src::main::contract_test;
use result::ResultTrait;
use array::ArrayTrait;
use debug::PrintTrait;
use starknet::ContractAddress;
use starknet::contract_address_const;
use traits::Into;

#[test]
fn test_set(){
    let class_hash = declare('contract_test').unwrap();
    let prepare_result = prepare(class_hash, ArrayTrait::new()).unwrap();
    let prepared_contract = PreparedContract {
        contract_address: prepare_result.contract_address,
        class_hash: prepare_result.class_hash,
        constructor_calldata: prepare_result.constructor_calldata
    };


    let deployed_contract_address = deploy(prepared_contract).unwrap();
    let mut calldata = ArrayTrait::new();
    calldata.append(500_u128.into());
    calldata.append(600_u128.into());
    calldata.append(700_u128.into());
    calldata.append(800_u128.into());
    calldata.append(900_u128.into());
    calldata.append(1000_u128.into());
    invoke(deployed_contract_address, 'set', calldata).unwrap();
    let return_data2 = call(deployed_contract_address, 'get',ArrayTrait::new() ).unwrap();
    assert(*return_data2.at(1_u32) == 500, *return_data2.at(5_u32)); 
}

#[test]
fn test_fib() {
    let x = contract_test::fib(0, 1, 13);
    assert(x == 233, 'fib(0, 1, 13) == 233');
}