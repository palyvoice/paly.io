Dynamo.under_test(Palyio.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Palyio.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
