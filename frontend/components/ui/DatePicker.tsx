"use client";

import {
  DatePicker as ChakraDatePicker,
  DatePickerInputProps,
  DatePickerRootProps,
  Portal,
} from "@chakra-ui/react";
import { LuCalendar } from "react-icons/lu";

interface props extends DatePickerRootProps {
  label?: string;
  inputProps?: DatePickerInputProps;
}

const DatePicker = ({ label, inputProps, ...rest }: props) => {
  return (
    <ChakraDatePicker.Root {...rest}>
      {label && <ChakraDatePicker.Label>{label}</ChakraDatePicker.Label>}
      <ChakraDatePicker.Control>
        <ChakraDatePicker.Input {...inputProps} />
        <ChakraDatePicker.IndicatorGroup>
          <ChakraDatePicker.Trigger>
            <LuCalendar />
          </ChakraDatePicker.Trigger>
        </ChakraDatePicker.IndicatorGroup>
      </ChakraDatePicker.Control>
      <Portal>
        <ChakraDatePicker.Positioner>
          <ChakraDatePicker.Content>
            <ChakraDatePicker.View view="day">
              <ChakraDatePicker.Header />
              <ChakraDatePicker.DayTable />
            </ChakraDatePicker.View>
            <ChakraDatePicker.View view="month">
              <ChakraDatePicker.Header />
              <ChakraDatePicker.MonthTable />
            </ChakraDatePicker.View>
            <ChakraDatePicker.View view="year">
              <ChakraDatePicker.Header />
              <ChakraDatePicker.YearTable />
            </ChakraDatePicker.View>
          </ChakraDatePicker.Content>
        </ChakraDatePicker.Positioner>
      </Portal>
    </ChakraDatePicker.Root>
  );
};

export default DatePicker;
