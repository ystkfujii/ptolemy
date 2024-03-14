import { useGetRoutes } from "../hooks/useGetRoutes"

type Props = {
}

export const Route: React.FC<Props> = ({  }) => {
  const data = useGetRoutes()
  return (
    <ul>
    {data.map((d) => (
      <li>url: {d.url}</li>
    ))}
    </ul>
  )
}
