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

library Map {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "pepemate", name: "Map", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x7462706570656d6174650000000000004d617000000000000000000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0000000400000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes32)
  Schema constant _keySchema = Schema.wrap(0x002001005f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (string, string, uint32[], bytes)
  Schema constant _valueSchema = Schema.wrap(0x00000004c5c565c4000000000000000000000000000000000000000000000000);

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
    fieldNames = new string[](4);
    fieldNames[0] = "name";
    fieldNames[1] = "description";
    fieldNames[2] = "spawnIndexes";
    fieldNames[3] = "terrain";
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
   * @notice Get name.
   */
  function getName(Entity id) internal view returns (string memory name) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get name.
   */
  function _getName(Entity id) internal view returns (string memory name) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Set name.
   */
  function setName(Entity id, string memory name) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((name)));
  }

  /**
   * @notice Set name.
   */
  function _setName(Entity id, string memory name) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((name)));
  }

  /**
   * @notice Get the length of name.
   */
  function lengthName(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of name.
   */
  function _lengthName(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of name.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemName(Entity id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of name.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemName(Entity id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Push a slice to name.
   */
  function pushName(Entity id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to name.
   */
  function _pushName(Entity id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from name.
   */
  function popName(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from name.
   */
  function _popName(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Update a slice of name at `_index`.
   */
  function updateName(Entity id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of name at `_index`.
   */
  function _updateName(Entity id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get description.
   */
  function getDescription(Entity id) internal view returns (string memory description) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 1);
    return (string(_blob));
  }

  /**
   * @notice Get description.
   */
  function _getDescription(Entity id) internal view returns (string memory description) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 1);
    return (string(_blob));
  }

  /**
   * @notice Set description.
   */
  function setDescription(Entity id, string memory description) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 1, bytes((description)));
  }

  /**
   * @notice Set description.
   */
  function _setDescription(Entity id, string memory description) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 1, bytes((description)));
  }

  /**
   * @notice Get the length of description.
   */
  function lengthDescription(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of description.
   */
  function _lengthDescription(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of description.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemDescription(Entity id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of description.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemDescription(Entity id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Push a slice to description.
   */
  function pushDescription(Entity id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 1, bytes((_slice)));
  }

  /**
   * @notice Push a slice to description.
   */
  function _pushDescription(Entity id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 1, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from description.
   */
  function popDescription(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 1, 1);
  }

  /**
   * @notice Pop a slice from description.
   */
  function _popDescription(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 1, 1);
  }

  /**
   * @notice Update a slice of description at `_index`.
   */
  function updateDescription(Entity id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of description at `_index`.
   */
  function _updateDescription(Entity id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get spawnIndexes.
   */
  function getSpawnIndexes(Entity id) internal view returns (uint32[4] memory spawnIndexes) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 2);
    return toStaticArray_uint32_4(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint32());
  }

  /**
   * @notice Get spawnIndexes.
   */
  function _getSpawnIndexes(Entity id) internal view returns (uint32[4] memory spawnIndexes) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 2);
    return toStaticArray_uint32_4(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint32());
  }

  /**
   * @notice Set spawnIndexes.
   */
  function setSpawnIndexes(Entity id, uint32[4] memory spawnIndexes) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 2, EncodeArray.encode(fromStaticArray_uint32_4(spawnIndexes)));
  }

  /**
   * @notice Set spawnIndexes.
   */
  function _setSpawnIndexes(Entity id, uint32[4] memory spawnIndexes) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 2, EncodeArray.encode(fromStaticArray_uint32_4(spawnIndexes)));
  }

  // The length of spawnIndexes
  uint256 constant lengthSpawnIndexes = 4;

  /**
   * @notice Get an item of spawnIndexes.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemSpawnIndexes(Entity id, uint256 _index) internal view returns (uint32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 2);
    uint256 dynamicLength = _byteLength / 4;
    uint256 staticLength = 4;

    if (_index < staticLength && _index >= dynamicLength) {
      return (uint32(bytes4(new bytes(0))));
    }

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 2, _index * 4, (_index + 1) * 4);
      return (uint32(bytes4(_blob)));
    }
  }

  /**
   * @notice Get an item of spawnIndexes.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemSpawnIndexes(Entity id, uint256 _index) internal view returns (uint32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 2);
    uint256 dynamicLength = _byteLength / 4;
    uint256 staticLength = 4;

    if (_index < staticLength && _index >= dynamicLength) {
      return (uint32(bytes4(new bytes(0))));
    }

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 2, _index * 4, (_index + 1) * 4);
      return (uint32(bytes4(_blob)));
    }
  }

  /**
   * @notice Update an element of spawnIndexes at `_index`.
   */
  function updateSpawnIndexes(Entity id, uint256 _index, uint32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 2, uint40(_index * 4), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of spawnIndexes at `_index`.
   */
  function _updateSpawnIndexes(Entity id, uint256 _index, uint32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 2, uint40(_index * 4), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get terrain.
   */
  function getTerrain(Entity id) internal view returns (bytes memory terrain) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 3);
    return (bytes(_blob));
  }

  /**
   * @notice Get terrain.
   */
  function _getTerrain(Entity id) internal view returns (bytes memory terrain) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 3);
    return (bytes(_blob));
  }

  /**
   * @notice Set terrain.
   */
  function setTerrain(Entity id, bytes memory terrain) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 3, bytes((terrain)));
  }

  /**
   * @notice Set terrain.
   */
  function _setTerrain(Entity id, bytes memory terrain) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 3, bytes((terrain)));
  }

  /**
   * @notice Get the length of terrain.
   */
  function lengthTerrain(Entity id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 3);
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

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 3);
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
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 3, _index * 1, (_index + 1) * 1);
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
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 3, _index * 1, (_index + 1) * 1);
      return (bytes(_blob));
    }
  }

  /**
   * @notice Push a slice to terrain.
   */
  function pushTerrain(Entity id, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 3, bytes((_slice)));
  }

  /**
   * @notice Push a slice to terrain.
   */
  function _pushTerrain(Entity id, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 3, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from terrain.
   */
  function popTerrain(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 3, 1);
  }

  /**
   * @notice Pop a slice from terrain.
   */
  function _popTerrain(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 3, 1);
  }

  /**
   * @notice Update a slice of terrain at `_index`.
   */
  function updateTerrain(Entity id, uint256 _index, bytes memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 3, uint40(_index * 1), uint40(_encoded.length), _encoded);
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
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 3, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get(
    Entity id
  )
    internal
    view
    returns (string memory name, string memory description, uint32[4] memory spawnIndexes, bytes memory terrain)
  {
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
  function _get(
    Entity id
  )
    internal
    view
    returns (string memory name, string memory description, uint32[4] memory spawnIndexes, bytes memory terrain)
  {
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
  function set(
    Entity id,
    string memory name,
    string memory description,
    uint32[4] memory spawnIndexes,
    bytes memory terrain
  ) internal {
    bytes memory _staticData;
    EncodedLengths _encodedLengths = encodeLengths(name, description, spawnIndexes, terrain);
    bytes memory _dynamicData = encodeDynamic(name, description, spawnIndexes, terrain);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    Entity id,
    string memory name,
    string memory description,
    uint32[4] memory spawnIndexes,
    bytes memory terrain
  ) internal {
    bytes memory _staticData;
    EncodedLengths _encodedLengths = encodeLengths(name, description, spawnIndexes, terrain);
    bytes memory _dynamicData = encodeDynamic(name, description, spawnIndexes, terrain);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    EncodedLengths _encodedLengths,
    bytes memory _blob
  )
    internal
    pure
    returns (string memory name, string memory description, uint32[4] memory spawnIndexes, bytes memory terrain)
  {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    name = (string(SliceLib.getSubslice(_blob, _start, _end).toBytes()));

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(1);
    }
    description = (string(SliceLib.getSubslice(_blob, _start, _end).toBytes()));

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(2);
    }
    spawnIndexes = toStaticArray_uint32_4(SliceLib.getSubslice(_blob, _start, _end).decodeArray_uint32());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(3);
    }
    terrain = (bytes(SliceLib.getSubslice(_blob, _start, _end).toBytes()));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   *
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory,
    EncodedLengths _encodedLengths,
    bytes memory _dynamicData
  )
    internal
    pure
    returns (string memory name, string memory description, uint32[4] memory spawnIndexes, bytes memory terrain)
  {
    (name, description, spawnIndexes, terrain) = decodeDynamic(_encodedLengths, _dynamicData);
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
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(
    string memory name,
    string memory description,
    uint32[4] memory spawnIndexes,
    bytes memory terrain
  ) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(
        bytes(name).length,
        bytes(description).length,
        spawnIndexes.length * 4,
        bytes(terrain).length
      );
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(
    string memory name,
    string memory description,
    uint32[4] memory spawnIndexes,
    bytes memory terrain
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        bytes((name)),
        bytes((description)),
        EncodeArray.encode(fromStaticArray_uint32_4(spawnIndexes)),
        bytes((terrain))
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    string memory name,
    string memory description,
    uint32[4] memory spawnIndexes,
    bytes memory terrain
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData;
    EncodedLengths _encodedLengths = encodeLengths(name, description, spawnIndexes, terrain);
    bytes memory _dynamicData = encodeDynamic(name, description, spawnIndexes, terrain);

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

/**
 * @notice Cast a dynamic array to a static array.
 * @dev In memory static arrays are just dynamic arrays without the 32 length bytes,
 * so this function moves the pointer to the first element of the dynamic array.
 * If the length of the dynamic array is smaller than the static length,
 * the function returns an uninitialized array to avoid memory corruption.
 * @param _value The dynamic array to cast.
 * @return _result The static array.
 */
function toStaticArray_uint32_4(uint32[] memory _value) pure returns (uint32[4] memory _result) {
  if (_value.length < 4) {
    // return an uninitialized array if the length is smaller than the fixed length to avoid memory corruption
    return _result;
  } else {
    // in memory static arrays are just dynamic arrays without the 32 length bytes
    // (without the length check this could lead to memory corruption)
    assembly {
      _result := add(_value, 0x20)
    }
  }
}

/**
 * @notice Copy a static array to a dynamic array.
 * @dev Static arrays don't have a length prefix, so this function copies the memory from the static array to a new dynamic array.
 * @param _value The static array to copy.
 * @return _result The dynamic array.
 */
function fromStaticArray_uint32_4(uint32[4] memory _value) pure returns (uint32[] memory _result) {
  _result = new uint32[](4);
  uint256 fromPointer;
  uint256 toPointer;
  assembly {
    fromPointer := _value
    toPointer := add(_result, 0x20)
  }
  Memory.copy(fromPointer, toPointer, 128);
}
