// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

// Import user types
import { Entity } from "../../Entity.sol";

library SessionMap {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "pepemate", name: "SessionMap", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x7462706570656d61746500000000000053657373696f6e4d6170000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0020010120000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes32)
  Schema constant _keySchema = Schema.wrap(0x002001005f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (bytes32, bytes)
  Schema constant _valueSchema = Schema.wrap(0x002001015fc40000000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "id";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](2);
    fieldNames[0] = "mapId";
    fieldNames[1] = "terrain";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get mapId.
   */
  function getMapId(Entity id) internal view returns (Entity mapId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return Entity.wrap(bytes32(_blob));
  }

  /**
   * @notice Get mapId.
   */
  function _getMapId(Entity id) internal view returns (Entity mapId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return Entity.wrap(bytes32(_blob));
  }

  /**
   * @notice Set mapId.
   */
  function setMapId(Entity id, Entity mapId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked(Entity.unwrap(mapId)), _fieldLayout);
  }

  /**
   * @notice Set mapId.
   */
  function _setMapId(Entity id, Entity mapId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked(Entity.unwrap(mapId)), _fieldLayout);
  }

  /**
   * @notice Get terrain.
   */
  function getTerrain(Entity id) internal view returns (bytes memory terrain) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (bytes(_blob));
  }

  /**
   * @notice Get terrain.
   */
  function _getTerrain(Entity id) internal view returns (bytes memory terrain) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (bytes(_blob));
  }

  /**
   * @notice Set terrain.
   */
  function setTerrain(Entity id, bytes memory terrain) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((terrain)));
  }

  /**
   * @notice Set terrain.
   */
  function _setTerrain(Entity id, bytes memory terrain) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((terrain)));
  }

  /**
   * @notice Get the length of terrain.
   */
  function lengthTerrain(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of terrain.
   */
  function _lengthTerrain(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of terrain.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemTerrain(Entity id, uint256 _index) internal view returns (bytes memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (bytes(_blob));
    }
  }

  /**
   * @notice Get an item of terrain.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemTerrain(Entity id, uint256 _index) internal view returns (bytes memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (bytes(_blob));
    }
  }

  /**
   * @notice Push a slice to terrain.
   */
  function pushTerrain(Entity id, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to terrain.
   */
  function _pushTerrain(Entity id, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from terrain.
   */
  function popTerrain(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from terrain.
   */
  function _popTerrain(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Update a slice of terrain at `_index`.
   */
  function updateTerrain(Entity id, uint256 _index, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of terrain at `_index`.
   */
  function _updateTerrain(Entity id, uint256 _index, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get(Entity id) internal view returns (Entity mapId, bytes memory terrain) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(Entity id) internal view returns (Entity mapId, bytes memory terrain) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(Entity id, Entity mapId, bytes memory terrain) internal {
    bytes memory _staticData = encodeStatic(mapId);

    EncodedLengths _encodedLengths = encodeLengths(terrain);
    bytes memory _dynamicData = encodeDynamic(terrain);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(Entity id, Entity mapId, bytes memory terrain) internal {
    bytes memory _staticData = encodeStatic(mapId);

    EncodedLengths _encodedLengths = encodeLengths(terrain);
    bytes memory _dynamicData = encodeDynamic(terrain);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(bytes memory _blob) internal pure returns (Entity mapId) {
    mapId = Entity.wrap(Bytes.getBytes32(_blob, 0));
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    EncodedLengths _encodedLengths,
    bytes memory _blob
  ) internal pure returns (bytes memory terrain) {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    terrain = (bytes(SliceLib.getSubslice(_blob, _start, _end).toBytes()));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths _encodedLengths,
    bytes memory _dynamicData
  ) internal pure returns (Entity mapId, bytes memory terrain) {
    (mapId) = decodeStatic(_staticData);

    (terrain) = decodeDynamic(_encodedLengths, _dynamicData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(Entity mapId) internal pure returns (bytes memory) {
    return abi.encodePacked(mapId);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(bytes memory terrain) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(bytes(terrain).length);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(bytes memory terrain) internal pure returns (bytes memory) {
    return abi.encodePacked(bytes((terrain)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    Entity mapId,
    bytes memory terrain
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(mapId);

    EncodedLengths _encodedLengths = encodeLengths(terrain);
    bytes memory _dynamicData = encodeDynamic(terrain);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(Entity id) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    return _keyTuple;
  }
}
