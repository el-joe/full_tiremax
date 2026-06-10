"use client"
import { createListCollection, Field, Portal, Select, Spinner } from '@chakra-ui/react';
import { useLocale } from 'next-intl';
import React, { useMemo } from 'react'
import { Control, Controller, FieldValues, Path } from 'react-hook-form';

interface IProps<T extends FieldValues> extends Omit<
    Select.RootProps,
    "collection"
> {
    label?: string | React.ReactNode;
    placeholder: string;
    list: { label: string; value: string }[];
    // onSelect?: (e: MenuSelectionDetails) => void;
    control?: Control<T>;
    name: Path<T>;
    err?: boolean;
    errMes?: string;
    triggerProps?: Select.TriggerProps
    containerProps?: Field.RootProps
    isLoading?: boolean
}

function DropSelectList<T extends FieldValues>({ list, placeholder, label, control, name, err,
    errMes, triggerProps, containerProps, isLoading, ...rest }: IProps<T>) {
    // const collection = createListCollection({ items: list })
    const collection = useMemo(() => {
        return createListCollection({
            items: list ?? [],
            itemToString: (list) => list.label,
            itemToValue: (list) => list.value,
        })
    }, [list])
    const locale = useLocale()
    const dir = locale === "ar" ? "rtl" : "ltr"
    return (
        <Field.Root {...containerProps} invalid={err}>
            {!!label && <Field.Label fontWeight={"semibold"}>{label}</Field.Label>}
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
                                <Select.Trigger bg={"gray-4"}>
                                    <Select.ValueText placeholder={placeholder} />
                                </Select.Trigger>
                                <Select.IndicatorGroup>
                                    <Select.ClearTrigger cursor={"pointer"} />
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
                <Select.Control>
                    <Select.Trigger {...triggerProps} bg={"gray-4"}>
                        <Select.ValueText placeholder={placeholder} />
                    </Select.Trigger>
                    <Select.IndicatorGroup>
                        {isLoading && (
                            <Spinner size="xs" borderWidth="1.5px" color="fg.muted" />
                        )}
                        <Select.ClearTrigger cursor={"pointer"} />
                        <Select.Indicator />
                    </Select.IndicatorGroup>
                </Select.Control>
                <Portal>
                    <Select.Positioner>
                        <Select.Content>
                            {collection.items.map((item) => (
                                <Select.Item item={item} key={item.value} dir={dir} >
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