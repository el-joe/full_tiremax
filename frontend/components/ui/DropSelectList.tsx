"use client"
import { createListCollection, Field, Portal, Select } from '@chakra-ui/react';
import React from 'react'
import { Control, Controller, FieldValues, Path } from 'react-hook-form';

interface IProps<T extends FieldValues> extends Omit<
    Select.RootProps,
    "collection"
> {
    label: string | React.ReactNode;
    placeholder: string;
    list: { label: string | React.ReactNode; value: string }[];
    // onSelect?: (e: MenuSelectionDetails) => void;
    control?: Control<T>;
    name: Path<T>;
    err?: boolean;
    errMes?: string;
    triggerProps?: Select.TriggerProps
    containerProps?: Field.RootProps
}

function DropSelectList<T extends FieldValues>({ list, placeholder, label, control, name, err,
    errMes, triggerProps, containerProps, ...rest }: IProps<T>) {
    const collection = createListCollection({ items: list })
    return (
        <Field.Root {...containerProps} invalid={err}>
            <Field.Label>{label}</Field.Label>
            {!!control ? (
                <Controller
                    control={control}
                    name={name}
                    render={({ field }) => (
                        <Select.Root
                            name={field.name}
                            value={field.value}
                            onValueChange={({ value }) => field.onChange(value)}
                            onInteractOutside={() => field.onBlur()}
                            collection={collection}
                        >
                            <Select.HiddenSelect />
                            <Select.Control>
                                <Select.Trigger>
                                    <Select.ValueText placeholder={placeholder} />
                                </Select.Trigger>
                                <Select.IndicatorGroup>
                                    <Select.Indicator />
                                </Select.IndicatorGroup>
                            </Select.Control>
                            <Portal>
                                <Select.Positioner>
                                    <Select.Content>
                                        {collection.items.map((item) => (
                                            <Select.Item item={item} key={item.value}>
                                                {item.label}
                                                <Select.ItemIndicator />
                                            </Select.Item>
                                        ))}
                                    </Select.Content>
                                </Select.Positioner>
                            </Portal>
                        </Select.Root>
                    )}
                />) : <Select.Root {...rest} collection={collection}>
                <Select.HiddenSelect />
                {/* <Select.Label>Select framework</Select.Label> */}
                <Select.Control>
                    <Select.Trigger {...triggerProps}>
                        <Select.ValueText placeholder={placeholder} />
                    </Select.Trigger>
                    <Select.IndicatorGroup>
                        <Select.Indicator />
                    </Select.IndicatorGroup>
                </Select.Control>
                <Portal>
                    <Select.Positioner>
                        <Select.Content>
                            {collection.items.map((item) => (
                                <Select.Item item={item} key={item.value}>
                                    {item.label}
                                    <Select.ItemIndicator />
                                </Select.Item>
                            ))}
                        </Select.Content>
                    </Select.Positioner>
                </Portal>
            </Select.Root>
            }
            <Field.ErrorText>{errMes}</Field.ErrorText>
        </Field.Root>
    )
}

export default DropSelectList