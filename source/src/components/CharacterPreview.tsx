import { emitNet, useCharacters, useConfig, useToggle } from "@/hooks";
import {
  Burger,
  Button,
  Collapse,
  Divider,
  Group,
  LoadingOverlay,
  Modal,
  Paper,
  SimpleGrid,
  Text,
  rgba,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import {
  IconWorld,
  IconCalendarDue,
  IconGenderBigender,
  IconCashBanknote,
  IconBuildingBank,
  IconBriefcase,
  IconBriefcaseFilled,
  IconMoodAngry,
  IconMoodAngryFilled,
  IconPlayerPlayFilled,
  IconClearAll,
  IconEraser,
  IconX,
} from "@tabler/icons-react";
import { useState } from "react";

export const CharacterPreview = ({
  character,
  activeCid,
  onClick,
}: {
  character: Character;
  activeCid: string | null;
  onClick: (cid: string | null) => void;
}) => {
  const { setOpen } = useToggle();
  const { getLocale } = useConfig();
  const { setCharacters } = useCharacters();
  const [opened, handler] = useDisclosure();
  const [deleteOpened, deleteHandler] = useDisclosure();
  const [isDeleting, setIsDeleting] = useState(false);

  return (
    <Collapse in={activeCid === null || activeCid === character.cid.toString()}>
      <Paper p="xs" bg={rgba("#242424", 0.5)}>
        <Group justify="space-between" align="center">
          <div>
            <Text fz="md" fw={600} lh={1.2}>
              {character.charinfo.firstname} {character.charinfo.lastname}
            </Text>
            <Text fz="sm" c="dimmed" lh={1}>
              {character.citizenid}
            </Text>
          </div>

          <Burger
            opened={opened}
            onClick={() => {
              if (opened) {
                handler.close();
                onClick(null);
              } else {
                handler.open();
                onClick(character.cid.toString());
              }
            }}
            size="sm"
            color="dimmed"
          />
        </Group>

        <Collapse in={opened} transitionDuration={1000}>
          <SimpleGrid cols={3} spacing="xs" verticalSpacing="xs" mt="md">
            <Group wrap="nowrap" gap={5}>
              <IconWorld stroke={1.25} color="var(--mantine-color-dimmed)" />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.nationality")}
                </Text>
                <Text fz="sm" lh={1} truncate="end" w={96}>
                  {character.charinfo.nationality}
                </Text>
              </div>
            </Group>

            <Group wrap="nowrap" gap={5}>
              <IconCalendarDue
                stroke={1.25}
                color="var(--mantine-color-dimmed)"
              />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.birthdate")}
                </Text>
                <Text fz="sm" lh={1}>
                  {character.charinfo.birthdate}
                </Text>
              </div>
            </Group>

            <Group wrap="nowrap" gap={5}>
              <IconGenderBigender
                stroke={1.25}
                color="var(--mantine-color-dimmed)"
              />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.gender")}
                </Text>
                <Text fz="sm" lh={1}>
                  {character.charinfo.gender ? "Female" : "Male"}
                </Text>
              </div>
            </Group>
          </SimpleGrid>

          <Divider my={6} />

          <SimpleGrid cols={3} spacing="xs" verticalSpacing="xs">
            <Group wrap="nowrap" gap={5}>
              <IconCashBanknote
                stroke={1.25}
                color="var(--mantine-color-dimmed)"
              />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.cash")}
                </Text>

                <Text fz="sm" lh={1}>
                  ${character.money.cash}
                </Text>
              </div>
            </Group>

            <Group wrap="nowrap" gap={5}>
              <IconBuildingBank
                stroke={1.25}
                color="var(--mantine-color-dimmed)"
              />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.bank")}
                </Text>

                <Text fz="sm" lh={1}>
                  ${character.money.bank}
                </Text>
              </div>
            </Group>
          </SimpleGrid>

          <Divider my={6} />

          <SimpleGrid cols={3} spacing="xs" verticalSpacing="xs">
            <Group wrap="nowrap" gap={5}>
              <IconBriefcase
                stroke={1.25}
                color="var(--mantine-color-dimmed)"
              />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.job")}
                </Text>

                <Text fz="sm" lh={1} truncate="end" w={96}>
                  {character.job.label}
                </Text>
              </div>
            </Group>

            <Group wrap="nowrap" gap={5}>
              <IconBriefcaseFilled
                stroke={1.25}
                color="var(--mantine-color-dimmed)"
              />
              <div>
                <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                  {getLocale("preview.grade")}
                </Text>

                <Text fz="sm" lh={1} truncate="end" w={96}>
                  {character.job.grade.name}
                </Text>
              </div>
            </Group>
          </SimpleGrid>

          {character.gang.name !== "none" && (
            <>
              <Divider my={6} />

              <SimpleGrid cols={3} spacing="xs" verticalSpacing="xs">
                <Group wrap="nowrap" gap={5}>
                  <IconMoodAngry
                    stroke={1.25}
                    color="var(--mantine-color-dimmed)"
                  />
                  <div>
                    <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                      {getLocale("preview.gang")}
                    </Text>

                    <Text fz="sm" lh={1} truncate="end" w={96}>
                      {character.gang.label}
                    </Text>
                  </div>
                </Group>

                <Group wrap="nowrap" gap={5}>
                  <IconMoodAngryFilled
                    stroke={1.25}
                    color="var(--mantine-color-dimmed)"
                  />
                  <div>
                    <Text fz={10} tt="uppercase" c="dimmed" lh={1}>
                      {getLocale("preview.grade")}
                    </Text>

                    <Text fz="sm" lh={1} truncate="end" w={96}>
                      {character.gang.grade.name}
                    </Text>
                  </div>
                </Group>
              </SimpleGrid>
            </>
          )}

          <Group gap="xs" justify="end" wrap="nowrap" mt="xl">
            <Button
              color="red"
              variant="light"
              leftSection={<IconClearAll size={16} />}
              onClick={deleteHandler.open}
            >
              {getLocale("preview.delete")}
            </Button>

            <Button
              leftSection={<IconPlayerPlayFilled size={16} />}
              onClick={() => {
                emitNet({
                  eventName: "selectCharacter",
                  payload: character.citizenid,
                  handler: () => {
                    handler.close();
                    onClick(null);
                    setOpen(false);
                  },
                });
              }}
            >
              {getLocale("preview.select")}
            </Button>
          </Group>
        </Collapse>
      </Paper>

      <Modal
        opened={deleteOpened}
        onClose={deleteHandler.close}
        title={getLocale("removing.delete_character")}
        closeOnClickOutside={false}
      >
        <LoadingOverlay
          visible={isDeleting}
          zIndex={1000}
          overlayProps={{ radius: "sm", blur: 2 }}
        />
        <Text fz="sm">
          {getLocale("removing.you_are_sure")} {character.charinfo.firstname}{" "}
          {character.charinfo.lastname}?
        </Text>
        <Text fz="xs" c="red">
          {getLocale("removing.action_irreversible")}
        </Text>

        <Group mt={10} gap="xs" justify="end">
          <Button
            leftSection={<IconX size={16} />}
            onClick={() => {
              deleteHandler.close();
            }}
          >
            {getLocale("removing.cancel")}
          </Button>
          <Button
            color="red"
            leftSection={<IconEraser size={16} />}
            onClick={() => {
              setIsDeleting(true);

              emitNet({
                eventName: "deleteCharacter",
                payload: character.citizenid,
                handler: (payload: Characters) => {
                  setCharacters(payload);

                  deleteHandler.close();
                  onClick(null);

                  setIsDeleting(false);
                },
              });
            }}
          >
            {getLocale("removing.delete")}
          </Button>
        </Group>
      </Modal>
    </Collapse>
  );
};
