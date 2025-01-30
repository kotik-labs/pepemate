import GameControlsSettings from "@/components/controls-settings";
import {
  Modal,
  ModalContent,
  ModalDescription,
  ModalHeader,
  ModalTitle,
  ModalTrigger,
} from "@/components/ui/modal";

type Props = {
  children: React.ReactNode;
};

export const ControlsModal = ({ children }: Props) => {
  return (
    <Modal>
      <ModalTrigger asChild>{children}</ModalTrigger>
      <ModalContent className="sm:max-w-[425px] bg-black text-white">
        <ModalHeader>
          <ModalTitle>Game Controls</ModalTitle>
          <ModalDescription>
            Click a button and press any key to set the control
          </ModalDescription>
        </ModalHeader>
        <GameControlsSettings />
      </ModalContent>
    </Modal>
  );
};
