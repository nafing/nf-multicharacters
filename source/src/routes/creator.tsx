import { OutletWrapper } from "@/components";
import {
  SimpleGrid,
  TextInput,
  rgba,
  Select,
  Group,
  Button,
  Checkbox,
} from "@mantine/core";
import { hasLength, isNotEmpty, useForm } from "@mantine/form";
import { DateInput } from "@mantine/dates";
import { createFileRoute, Link } from "@tanstack/react-router";
import { useConfig, emitNet, useToggle } from "@/hooks";

export const Route = createFileRoute("/creator")({
  component: Creator,
});

function Creator() {
  const { cid, disableCancel } = Route.useSearch() as {
    cid: number;
    disableCancel: boolean;
  };

  const { setOpen } = useToggle();
  const { config, getLocale } = useConfig();

  const maxDate = () => {
    const date = new Date();
    date.setFullYear(date.getFullYear() - 18);

    return date;
  };

  const form = useForm({
    initialValues: {
      cid: cid || 1,
      firstname: "",
      lastname: "",
      birthdate: maxDate(),
      nationality: config.nationalities[0],
      gender: "male",
      terms_of_server: false,
    },

    validate: {
      firstname: hasLength({ min: 2, max: 32 }, getLocale("creator.error")),
      lastname: hasLength({ min: 2, max: 32 }, getLocale("creator.error")),
      nationality: isNotEmpty(getLocale("creator.is_required")),
    },
  });

  const getYears = () => {
    return new Date().getFullYear() - form.values.birthdate.getFullYear();
  };

  return (
    <OutletWrapper
      title={getLocale("creator.character_creator")}
      onMount={() => {
        emitNet({
          eventName: "setActiveCharacter",
          payload: "default",
        });
      }}
    >
      <form
        onSubmit={form.onSubmit((values) => {
          const convertedValues = {
            cid: values.cid,
            firstname: values.firstname,
            lastname: values.lastname,
            birthdate: values.birthdate.toISOString().split("T")[0],
            nationality: values.nationality,
            gender: values.gender,
          };

          emitNet({
            eventName: "createCharacter",
            payload: convertedValues,
            handler() {
              setOpen(false);
            },
          });
        })}
      >
        <SimpleGrid cols={2} spacing="xs" verticalSpacing="xs">
          <TextInput
            label={getLocale("creator.firstname")}
            placeholder="John"
            variant="filled"
            styles={{
              input: {
                backgroundColor: rgba("#242424", 0.5),
              },
            }}
            key={form.key("firstname")}
            {...form.getInputProps("firstname")}
          />

          <TextInput
            label={getLocale("creator.lastname")}
            placeholder="Doe"
            variant="filled"
            styles={{
              input: {
                backgroundColor: rgba("#242424", 0.5),
              },
            }}
            key={form.key("lastname")}
            {...form.getInputProps("lastname")}
          />

          <Select
            label={getLocale("creator.gender")}
            placeholder={getLocale("creator.gender")}
            variant="filled"
            styles={{
              input: {
                backgroundColor: rgba("#242424", 0.5),
              },
            }}
            data={[
              {
                value: "male",
                label: getLocale("creator.male"),
              },
              {
                value: "female",
                label: getLocale("creator.female"),
              },
            ]}
            key={form.key("gender")}
            {...form.getInputProps("gender")}
            allowDeselect={false}
            onChange={(value) => {
              form.setFieldValue("gender", value as string, {
                forceUpdate: true,
              });

              emitNet({
                eventName: "setGender",
                payload: value,
              });
            }}
          />

          <DateInput
            label={`${getLocale("creator.birthdate")} (${getYears()} ${getLocale("creator.years")})`}
            placeholder="YYYY-MM-DD"
            variant="filled"
            styles={{
              input: {
                backgroundColor: rgba("#242424", 0.5),
              },
            }}
            valueFormat="YYYY-MM-DD"
            key={form.key("birthdate")}
            {...form.getInputProps("birthdate")}
            minDate={new Date(1950, 0, 1)}
            maxDate={maxDate()}
          />

          <Select
            label={getLocale("creator.nationality")}
            placeholder={getLocale("creator.nationality")}
            variant="filled"
            styles={{
              input: {
                backgroundColor: rgba("#242424", 0.5),
              },
            }}
            data={config.nationalities}
            key={form.key("nationality")}
            {...form.getInputProps("nationality")}
            searchable
            allowDeselect={false}
          />
        </SimpleGrid>

        <Checkbox
          mt="lg"
          label={getLocale("creator.terms_of_server")}
          description={getLocale("creator.terms_of_server_description")}
          key={form.key("terms_of_server")}
          {...form.getInputProps("terms_of_server", { type: "checkbox" })}
          styles={{
            description: {
              lineHeight: "0",
            },
          }}
        />

        <Group gap="xs" wrap="nowrap" mt="xl">
          {!disableCancel && (
            <Button fullWidth color="red" component={Link} to="/characters">
              {getLocale("creator.cancel")}
            </Button>
          )}

          <Button
            fullWidth
            type="submit"
            disabled={!form.values.terms_of_server}
          >
            {getLocale("creator.create")}
          </Button>
        </Group>
      </form>
    </OutletWrapper>
  );
}
