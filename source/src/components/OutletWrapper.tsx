import {
  Paper,
  Stack,
  Title,
  Divider,
  ScrollArea,
  Group,
  Box,
  Transition,
  Button,
} from "@mantine/core";
import { useMounted } from "@mantine/hooks";
import { Link } from "@tanstack/react-router";

export const OutletWrapper = ({
  title,
  back,
  forward,
  children,
  expandChildren,
  topChildren,
  bottomChildren,
  onMount,
}: {
  title: string;
  back?: string;
  forward?: string;
  children: React.ReactNode;
  expandChildren?: React.ReactNode;
  topChildren?: React.ReactNode;
  bottomChildren?: React.ReactNode;
  onMount?: () => void;
}) => {
  const mounted = useMounted();
  const _L = (str: string) => str;

  return (
    <Transition mounted={mounted} transition="pop" onEnter={onMount}>
      {(styles) => (
        <Paper style={styles} className="outlet-wrapper">
          <Stack gap="xs" h="100%">
            <div>
              <Group gap="xs" pt="xs" px="xs" justify="space-between">
                <Title order={5} tt="uppercase">
                  {_L(title)}
                </Title>

                {expandChildren}
              </Group>

              <Divider mt={4} />
            </div>

            {topChildren && <Box px="xs">{topChildren}</Box>}

            <ScrollArea px="xs" pb={back || forward ? 0 : "xs"}>
              <Stack gap={6} h="100%">
                {children}
              </Stack>
            </ScrollArea>

            {bottomChildren && bottomChildren}

            {back || forward ? (
              <Group gap="xs" wrap="nowrap" px="xs" pb="xs">
                {back ? (
                  <Button fullWidth component={Link} to={back}>
                    {_L("navigation.back")}
                  </Button>
                ) : null}

                {forward ? (
                  <Button fullWidth component={Link} to={forward}>
                    {_L("navigation.next")}
                  </Button>
                ) : null}
              </Group>
            ) : null}
          </Stack>
        </Paper>
      )}
    </Transition>
  );
};
