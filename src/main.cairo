use array::ArrayTrait;
use starknet::ContractAddress;
use starknet::StorageAccess;
use starknet::StorageBaseAddress;
use starknet::SyscallResult;
use starknet::storage_read_syscall;
use starknet::storage_write_syscall;
use starknet::storage_address_from_base_and_offset;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use starknet::contract_address;

#[derive(Copy, Drop)]
struct Market {
    address: ContractAddress,
    is_supported: u128,
    deposit_min_amount: u128,
    deposit_max_amount: u128,
    loan_min_amount: u128,
    loan_max_amount: u128,
    empiric_key: u128,
}

impl Market_StorageAccess of StorageAccess::<Market> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<Market> {
        Result::Ok(
            Market {
                address: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 0_u8)
                )?.try_into().unwrap(),
                is_supported: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 1_u8)
                )?.try_into().unwrap(),
                deposit_min_amount: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 2_u8)
                )?.try_into().unwrap(),
                deposit_max_amount: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 3_u8)
                )?.try_into().unwrap(),
                loan_min_amount: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 4_u8)
                )?.try_into().unwrap(),
                loan_max_amount: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 5_u8)
                )?.try_into().unwrap(),
                empiric_key: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 6_u8)
                )?.try_into().unwrap(),
            }
        )
    }

    fn write(address_domain: u32, base: StorageBaseAddress, value: Market) -> SyscallResult::<()> {
        storage_write_syscall(
            address_domain, storage_address_from_base_and_offset(base, 0_u8), value.address.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 1_u8),
            value.is_supported.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 2_u8),
            value.deposit_min_amount.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 3_u8),
            value.deposit_max_amount.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 4_u8),
            value.loan_min_amount.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 5_u8),
            value.loan_max_amount.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 6_u8),
            value.empiric_key.into()
        )
    }
}

impl MarketSerde of serde::Serde::<Market> {
    fn serialize(ref serialized: Array::<felt252>, input: Market) {
        serde::Serde::<ContractAddress>::serialize(ref serialized, input.address);
        serde::Serde::<u128>::serialize(ref serialized, input.is_supported);
        serde::Serde::<u128>::serialize(ref serialized, input.deposit_min_amount);
        serde::Serde::<u128>::serialize(ref serialized, input.deposit_max_amount);
        serde::Serde::<u128>::serialize(ref serialized, input.loan_min_amount);
        serde::Serde::<u128>::serialize(ref serialized, input.loan_max_amount);
        serde::Serde::<u128>::serialize(ref serialized, input.empiric_key);
    }
    fn deserialize(ref serialized: Span::<felt252>) -> Option::<Market> {
        Option::Some(
            Market {
                address: serde::Serde::<ContractAddress>::deserialize(ref serialized)?,
                is_supported: serde::Serde::<u128>::deserialize(ref serialized)?,
                deposit_min_amount: serde::Serde::<u128>::deserialize(ref serialized)?,
                deposit_max_amount: serde::Serde::<u128>::deserialize(ref serialized)?,
                loan_min_amount: serde::Serde::<u128>::deserialize(ref serialized)?,
                loan_max_amount: serde::Serde::<u128>::deserialize(ref serialized)?,
                empiric_key: serde::Serde::<u128>::deserialize(ref serialized)?,
            }
        )
    }
}

#[contract]
mod contract_test {
    use starknet::ContractAddress;
    use super::Market;
    use starknet::get_caller_address;
    use array::ArrayTrait;


    struct Storage{
    value : felt252,
    _market : Market
    }

    #[view]
    fn add(a: felt252, b: felt252) -> felt252 {
        a+b
    }

    fn fib(a: felt252, b: felt252, n: felt252) -> felt252 {
        match gas::withdraw_gas() {
            Option::Some(_) => {},
            Option::None(_) => {
                let mut data = ArrayTrait::new();
                data.append('Out of gas');
                panic(data);
            },
        }
        match n {
            0 => a,
            _ => fib(b, a + b, n - 1),
        }
    }

    #[external]
    fn set(a: u128 , b : u128 , c : u128, d : u128, e : u128, f : u128){
        let add= get_caller_address();
        let x = Market{
            address: add,
            is_supported: a,
            deposit_min_amount: b,
            deposit_max_amount: c,
            loan_min_amount: d,
            loan_max_amount: e,
            empiric_key: f,
        };
        _market::write(x);
    }

    #[view]
    fn get() -> Market {
        let x =  _market::read();
        return x;
    }

}