import { CharacterPreview, OutletWrapper } from "@/components";
import { emitNet, useCharacters, useConfig } from "@/hooks";
import { Collapse, Tooltip, Paper, rgba, Center } from "@mantine/core";
import { IconPlus } from "@tabler/icons-react";
import { createFileRoute, Link } from "@tanstack/react-router";
import { useState } from "react";

export const Route = createFileRoute("/characters")({
  component: Characters,
});

function Characters() {
  const { config, getLocale } = useConfig();
  const { characters } = useCharacters();
  const [activeCid, setActiveCid] = useState<string | null>(null);

  const getUnusedCid = () => {
    const cids = Object.values(characters).map((v) => v.cid);

    const unusedCid = Array.from({ length: config.maxCharacters })
      .map((_, i) => i + 1)
      .find((i) => !cids.includes(i));

    return unusedCid ?? 1;
  };

  return (
    <OutletWrapper
      title={getLocale("characters_title")}
      onMount={() => {
        emitNet({
          eventName: "setActiveCharacter",
        });
      }}
    >
      {Object.values(characters).map((char) => (
        <CharacterPreview
          key={char.cid}
          character={char}
          activeCid={activeCid}
          onClick={(cid) => {
            if (cid === activeCid) {
              return;
            }

            setActiveCid(cid);

            emitNet({
              eventName: "setActiveCharacter",
              payload: cid,
            });
          }}
        />
      ))}

      <Collapse
        in={
          activeCid === null &&
          Object.keys(characters).length !== config.maxCharacters
        }
      >
        <Tooltip
          position="bottom"
          withArrow
          label={getLocale("create_new_character")}
        >
          <Paper
            bg={rgba("#242424", 0.5)}
            p={10}
            style={{ cursor: "pointer" }}
            component={Link}
            to="/creator"
            search={{
              cid: getUnusedCid(),
            }}
          >
            <Center>
              <IconPlus size={24} color="var(--mantine-color-dimmed)" />
            </Center>
          </Paper>
        </Tooltip>
      </Collapse>
    </OutletWrapper>
  );
}
