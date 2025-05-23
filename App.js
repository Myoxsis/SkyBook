import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, Button, FlatList, StyleSheet } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

export default function App() {
  const [date, setDate] = useState('');
  const [aircraft, setAircraft] = useState('');
  const [duration, setDuration] = useState('');
  const [notes, setNotes] = useState('');
  const [flights, setFlights] = useState([]);

  useEffect(() => {
    const loadFlights = async () => {
      try {
        const stored = await AsyncStorage.getItem('flights');
        if (stored) {
          setFlights(JSON.parse(stored));
        }
      } catch (err) {
        console.error('Failed to load flights', err);
      }
    };
    loadFlights();
  }, []);

  const saveFlights = async (newFlights) => {
    try {
      await AsyncStorage.setItem('flights', JSON.stringify(newFlights));
    } catch (err) {
      console.error('Failed to save flights', err);
    }
  };

  const addFlight = () => {
    const newFlight = { id: Date.now().toString(), date, aircraft, duration, notes };
    const updated = [newFlight, ...flights];
    setFlights(updated);
    saveFlights(updated);
    setDate('');
    setAircraft('');
    setDuration('');
    setNotes('');
  };

  const renderFlight = ({ item }) => (
    <View style={styles.flightItem}>
      <Text style={styles.flightText}>{`${item.date} - ${item.aircraft} - ${item.duration} hrs`}</Text>
      {item.notes ? <Text style={styles.notes}>{item.notes}</Text> : null}
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>SkyBook</Text>
      <TextInput
        style={styles.input}
        placeholder="Date"
        value={date}
        onChangeText={setDate}
      />
      <TextInput
        style={styles.input}
        placeholder="Aircraft"
        value={aircraft}
        onChangeText={setAircraft}
      />
      <TextInput
        style={styles.input}
        placeholder="Duration (hrs)"
        value={duration}
        onChangeText={setDuration}
        keyboardType="numeric"
      />
      <TextInput
        style={[styles.input, styles.notesInput]}
        placeholder="Notes"
        value={notes}
        onChangeText={setNotes}
      />
      <Button title="Add Flight" onPress={addFlight} />
      <FlatList
        data={flights}
        renderItem={renderFlight}
        keyExtractor={(item) => item.id}
        style={styles.list}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 50,
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 10,
    marginBottom: 10,
    borderRadius: 4,
  },
  notesInput: {
    height: 80,
  },
  list: {
    marginTop: 20,
  },
  flightItem: {
    paddingVertical: 10,
    borderBottomColor: '#ccc',
    borderBottomWidth: 1,
  },
  flightText: {
    fontSize: 16,
  },
  notes: {
    color: '#555',
  },
});
