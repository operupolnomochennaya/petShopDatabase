INSERT INTO accessorie(id, name)
VALUES
  (1001, 'Test_Acc_1'),
  (1002, 'Test_Acc_2'),
  (1003, 'Test_Acc_3')
ON CONFLICT (id) DO NOTHING;