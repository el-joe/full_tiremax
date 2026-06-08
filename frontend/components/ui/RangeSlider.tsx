import { Field, HStack, Slider, Text } from "@chakra-ui/react";
import React, { useEffect, useState } from "react";
// import NumberInput from "./NumberInput";

interface Props {
  maxVal?: number;
  defaultValue?: number[];
  step?: number;
  label?: string;
  onChange?: (v: number[]) => void;
  onRangeChangeEnd?: (v: number[]) => void;
}

const RangeSlider = ({
  maxVal = 100,
  defaultValue = [0, maxVal],
  step = 1,
  label,
  onChange,
  onRangeChangeEnd,
  ...rest
}: Props & Slider.RootProps & React.RefAttributes<HTMLDivElement>) => {
  const [realValues, setRealValues] = useState<number[]>(defaultValue);

  const getRangeValue = (realValues: number[]): number[] => {
    const rangeValue = realValues.map((RV) => +((RV / maxVal) * 100).toFixed());
    if (rangeValue[1] <= 1) rangeValue[1] = 2;
    return rangeValue;
  };
  const changeRangeValue = (newRangeValue: number[]) => {
    const newRealValues = newRangeValue.map(
      (RangeV) => +((RangeV / 100) * maxVal).toFixed(),
    );
    setRealValues(newRealValues);
  };
  useEffect(() => {
    onChange?.(realValues);
    return () => { };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [realValues]);
  return (
    <Field.Root gap={"16px"}>
      <Field.Label fontWeight={"semibold"} fontSize={"14px"}>{label}</Field.Label>
      <Slider.Root
        step={step}
        w="full"
        p={"16px"}
        bg={"#F3F3F3"}
        rounded={"8px"}
        value={getRangeValue(realValues)}
        onValueChange={(v) => changeRangeValue(v.value)}
        onValueChangeEnd={() => onRangeChangeEnd?.(realValues)}
        minStepsBetweenThumbs={2}
        {...rest}
      >
        {/* <Slider.ValueText /> */}
        <Slider.Control>
          <Slider.Track h={"4px"}>
            <Slider.Range bg={"primary"} />
          </Slider.Track>
          <Slider.Thumbs borderColor={"primary"} w={"10px"} h={"18px"} cursor={"pointer"} />
        </Slider.Control>
        <HStack justify={"space-between"}>
          <Text>{realValues[0]}</Text>
          <Text>{realValues[1]}</Text>
        </HStack>
      </Slider.Root>
    </Field.Root>
  );
};

export default RangeSlider;
