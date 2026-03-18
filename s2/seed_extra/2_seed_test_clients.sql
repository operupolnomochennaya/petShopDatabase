INSERT INTO client(id, name, surname, passport_data, segment, preferences, phones, notes)
VALUES
  (1000001, 'Test', 'Client1', 'TESTPASS001', 'A', '{"newsletter": true}', ARRAY['+70000000001'], 'seed row 1'),
  (1000002, 'Test', 'Client2', 'TESTPASS002', 'B', '{"newsletter": false}', ARRAY['+70000000002'], 'seed row 2')
ON CONFLICT (id) DO NOTHING;