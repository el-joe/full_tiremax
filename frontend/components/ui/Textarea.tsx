import React from "react";
import { UseFormRegisterReturn } from "react-hook-form";
import { Textarea as ChakraTextarea, Field, TextareaProps } from "@chakra-ui/react";

interface ITextareaProps
  extends TextareaProps {
  label?: string;
  register?: UseFormRegisterReturn;
  err?: boolean;
  errMes?: string;
}

const Textarea: React.FC<ITextareaProps> = ({
  label,
  register,
  err,
  errMes,
  ...rest
}) => {
  return (
    <Field.Root invalid={err}>
      {label && <Field.Label>{label}</Field.Label>}
      <ChakraTextarea _focus={{ outline: "1px solid {colors.primary}", border: "1px solid {colors.primary}" }} rounded={"16px"} p="16px" bg="#F9FAFB" {...register} {...rest} />
      {errMes && <Field.ErrorText>{errMes}</Field.ErrorText>}
    </Field.Root>
  );
};

export default Textarea;