-- Índices para tabelas despejadas
--

--
-- Índices para tabela `dim_clientes`
--
ALTER TABLE `dim_clientes`
  ADD PRIMARY KEY (`Id_DimClient`);

--
-- Índices para tabela `dim_datas`
--
ALTER TABLE `dim_datas`
  ADD PRIMARY KEY (`id_data`),
  ADD KEY `year_week` (`ano`,`dia_ano`);

--
-- Índices para tabela `dim_fornecedores`
--
ALTER TABLE `dim_fornecedores`
  ADD PRIMARY KEY (`Id_DimFornec`);

--
-- Índices para tabela `dim_funcionarios`
--
ALTER TABLE `dim_funcionarios`
  ADD PRIMARY KEY (`Id_DimFunc`);

--
-- Índices para tabela `dim_pedidos`
--
ALTER TABLE `dim_pedidos`
  ADD PRIMARY KEY (`Id_DimPedi`);

--
-- Índices para tabela `dim_produtos`
--
ALTER TABLE `dim_produtos`
  ADD PRIMARY KEY (`Id_DimProdutos`);

--
-- Índices para tabela `fat_empresa`
--
ALTER TABLE `fat_empresa`
  ADD PRIMARY KEY (`Id_Fat`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `dim_clientes`
--
ALTER TABLE `dim_clientes`
  MODIFY `Id_DimClient` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;

--
-- AUTO_INCREMENT de tabela `dim_datas`
--
ALTER TABLE `dim_datas`
  MODIFY `id_data` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;

--
-- AUTO_INCREMENT de tabela `dim_fornecedores`
--
ALTER TABLE `dim_fornecedores`
  MODIFY `Id_DimFornec` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;

--
-- AUTO_INCREMENT de tabela `dim_funcionarios`
--
ALTER TABLE `dim_funcionarios`
  MODIFY `Id_DimFunc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;

--
-- AUTO_INCREMENT de tabela `dim_pedidos`
--
ALTER TABLE `dim_pedidos`
  MODIFY `Id_DimPedi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;

--
-- AUTO_INCREMENT de tabela `dim_produtos`
--
ALTER TABLE `dim_produtos`
  MODIFY `Id_DimProdutos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;

--
-- AUTO_INCREMENT de tabela `fat_empresa`
--
ALTER TABLE `fat_empresa`
  MODIFY `Id_Fat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;
COMMIT;
